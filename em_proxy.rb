require 'em-proxy'
require 'redis'
require 'sidekiq'
require 'cgi'
require './app/workers/bucardo_reset_worker'
require './app/workers/bucardo_stop_worker'


redis = Redis.new(:host => "127.0.0.1", :port => 6379, :db => 0)
puts "Resetting slave db"
redis.set("bucardo_active", "true")

#redis.set("bucardo_active", "false")
#BucardoResetWorker.perform_async

def detect_tokens(data, request_id, redis)
  #tokens = data.scan(/_sample_app_session=.*?;/)
  tokens = data.scan(/<input name=\"authenticity_token\" type=\"hidden\" value=\"(.*?)\" /)

  if tokens.size > 0
    ip = request_id.split('-')[4..7].join('.')
    redis.set(ip, tokens[0][0])
    p tokens
    p ip
    puts "Found token " + tokens[0][0] + " and saved it for IP " + ip
  end  
end  

def replace_tokens(data, request_id, redis)
  ip = request_id.split('-')[4..7].join('.')
  tokens = data.scan(/authenticity_token=(.*?)&session/)
  
  if tokens.size > 0
    puts "Found token in request."
    stored_token = redis.get(ip)
    if stored_token
      puts "Found stored token, replacing " + tokens[0][0] + " with " + stored_token + "."
      data = data.gsub(tokens[0][0], CGI.escape(stored_token))
    end   
  end  
  data
  #data.gsub(/_sample_app_session=.*?;/, '_sample_app_session=test_token;')
end

Proxy.start(:host => "0.0.0.0", :port => 8000, :debug => false) do |conn|
  @start = Time.now
  @data = Hash.new("")
  @bucardo_stopped = false
  @request_id = nil
  conn.server :shadow, :host => '178.62.228.7', :port => 3000    # testing, internal only
  conn.server :production, :host => '188.166.38.32', :port => 3000    # production, will render resposne


  conn.on_data do |data|
     p data
    if redis.get('bucardo_active').to_s == "true"
      first_line = data.lines.first
      verb = first_line.split("/")[0].strip
      url = first_line.scan(/ \/.* /)[0]
      if ['POST','DELETE','PATCH'].include? ''#verb
        puts "Processing non-idempotent request and disabling non-idempotent requests untill next sync."
        redis.set('bucardo_active', "false")
        @bucardo_stopped = true
        #BucardoStopWorker.perform_async
      else
        puts "Processing idempotent request."
      end

      @request_id = data.scan(/X-Request-Id: .*$/).first.split(":")[1].strip.gsub!(/\./, '-')
      redis.hset(@request_id, :request, data)
      redis.hset(@request_id, :url, url)
      redis.hset(@request_id, :verb, verb)
      redis.hset(@request_id, :time, Time.now.ctime)
    else
      puts "Bucardo is down, skipping request."
    end
    {:shadow => replace_tokens(data, @request_id, redis), :production => data}
  end

  conn.on_response do |server, resp|
    @data[server] += resp
    resp if server == :production
  end

  conn.on_finish do |name|
    p [:on_finish, name, Time.now - @start]
    
    if @request_id
      redis.hset(@request_id, :production, @data[:production])
      redis.hset(@request_id, :shadow, @data[:shadow])
      redis.hset(@request_id, :commit_hash, redis.get("commit_hash"))
    else
      puts "Finished ignored request by " + name
    end

    if name == :shadow
      detect_tokens(@data[:shadow], @request_id, redis)
    end  
    :close if name == :production

    if @bucardo_stopped && redis.get('bucardo_working').to_s != "true"
      puts "Finished non-idempotent request, reseting bucardo."
      #BucardoResetWorker.perform_async
    end
  end
end
