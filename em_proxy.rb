require 'em-proxy'
require 'redis'
redis = Redis.new(:host => "127.0.0.1", :port => 6379, :db => 0)
redis.set("bucardo_active", "true")
Proxy.start(:host => "0.0.0.0", :port => 8000, :debug => false) do |conn|
  @start = Time.now
  @data = Hash.new("")
  @request_id = nil
  conn.server :production, :host => ENV['MASTER_SHADOW'], :port => 3000    # production, will render resposne
  conn.server :shadow, :host => ENV['SLAVE_SHADOW'], :port => 3001    # testing, internal only

  conn.on_data do |data|
    first_line = data.lines.first
    verb = first_line.split("/")[0].strip
    url = first_line.scan(/ \/.* /)[0]

    if ['POST','DELETE','PATCH'].include? verb
      puts "Detected " + verb
      if redis.get('bucardo_active').to_s == "true"
        puts "Processing non-idempotent request."  
        puts "Disabling non-idempotent requests untill next sync."
        redis.set('bucardo_active', "false")
        BucardoManagerWorker.perform_async
      else
        puts "Bucardo is not active, ignoring request."  
      end 
    else
      @request_id = data.scan(/X-Request-Id: .*$/).first.split(":")[1].strip.gsub!(/\./, '-')
      redis.hset(@request_id, :request, data)
      redis.hset(@request_id, :url, url)
      redis.hset(@request_id, :verb, verb)
      redis.hset(@request_id, :time, Time.now.ctime)
    end  

    data

  end

  conn.on_response do |server, resp|
    @data[server] += resp
    resp if server == :production
  end

  conn.on_finish do |name|
    p [:on_finish, name, Time.now - @start]
    redis.hset(@request_id, :production, @data[:production])
    redis.hset(@request_id, :shadow, @data[:shadow])
    redis.hset(@request_id, :commit_hash, redis.get("commit_hash"))
    #če je biu bucardo ustavlen sproži postopke da se spet prižge
    :close if name == :production
  end
end
