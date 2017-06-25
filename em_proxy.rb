require 'em-proxy'
require 'redis'
require 'uuid'
redis = Redis.new(:host => "127.0.0.1", :port => 6379, :db => 0)
uuid = UUID.new
id = 0
Proxy.start(:host => "0.0.0.0", :port => 8000, :debug => false) do |conn|
  @start = Time.now
  @data = Hash.new("")

  conn.server :production, :host => ENV['MASTER_SHADOW'], :port => 3000    # production, will render resposne
  conn.server :shadow, :host => ENV['SLAVE_SHADOW'], :port => 3000    # testing, internal only

  conn.on_data do |data|
    id = "request-" + uuid.generate.to_s 
    redis.hset(id, :request, data)
    redis.hset(id, :time, Time.now.ctime)
    data
  end

  conn.on_response do |server, resp|
    @data[server] += resp
    resp if server == :production
  end

  conn.on_finish do |name|
    p [:on_finish, name, Time.now - @start]
    redis.hset(id, :production, @data[:production])
    redis.hset(id, :shadow, @data[:shadow])
    :close if name == :production
  end
end
