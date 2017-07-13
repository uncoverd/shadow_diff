require 'em-proxy'
require 'redis'
require 'sidekiq'
require 'cgi'
require './app/workers/bucardo_reset_worker'
require './app/workers/bucardo_stop_worker'

SCAN_REGEX = {#'csrf_token' => /<input name=\"authenticity_token\" type=\"hidden\" value=\"(.*?)\" /,
              #'session_token' => /_sample_app_session=(.*?); path/,
              'remember_token' => /remember_token=(.*?); path/}
              #'csrf_meta_tag' => /<meta content=\"(.*?)\" name=\"csrf-token\" \/>/}
REPLACE_REGEX = {#'csrf_token' => /authenticity_token=(.*?)&session/,
              #'session_token' => /_sample_app_session=(.*?);/,
              'remember_token' => /remember_token=(.*?);/}
              #'csrf_meta_tag' => /authenticity_token=(.*?)(&|$)/}
              #/authenticity_token=(.*?)$
ESCAPED_TOKENS = ['csrf_token', 'csrf_meta_tag']

redis = Redis.new(:host => "127.0.0.1", :port => 6379, :db => 0)

puts "Resetting slave db"
#redis.set("bucardo_active", "true")

redis.set("bucardo_active", "false")
BucardoResetWorker.perform_async

def detect_tokens(data, request_id)
  redis = Redis.new(:host => "127.0.0.1", :port => 6379, :db => 0)
  ip = request_id.split('-')[4..7].join('.')

  SCAN_REGEX.keys.each do |token_name|
    token = data.scan(SCAN_REGEX[token_name])
    if token.size > 0
      redis.hset(ip, token_name, token[0][0])
      puts "Found " + token_name.to_s + " " +token[0][0]
    end
  end
  puts "Saved them for IP " + ip
end

def replace_tokens(data, request_id)
  redis = Redis.new(:host => "127.0.0.1", :port => 6379, :db => 0)
  ip = request_id.split('-')[4..7].join('.')
  csrf_token = data.scan(/authenticity_token=(.*?)&session/)
  session_token = data.scan(/_sample_app_session=(.*?);/)

  SCAN_REGEX.keys.each do |token_name|
    token = data.scan(REPLACE_REGEX[token_name])
    if token.size > 0
      puts "Found " + token_name.to_s + " in request."
      stored_token = redis.hget(ip, token_name)
      if stored_token
        puts "Found stored " + token_name.to_s + " token, replacing " + token[0][0] + " with " + stored_token + "."
        escaped_token = stored_token
        if ESCAPED_TOKENS.include?(token_name)
          puts "Escaping " + token_name.to_s
          escaped_token = CGI.escape(stored_token)
        end
        data = data.gsub(token[0][0], escaped_token)
      end

    end
  end
  data
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
      if ['POST','DELETE','PATCH'].include? verb
        puts "Processing non-idempotent request stopping bucardo sync."
        #redis.set('bucardo_active', "false")
        #@bucardo_stopped = true
        BucardoStopWorker.perform_async
      else
        puts "Processing idempotent request."
      end

      @request_id = data.scan(/X-Request-Id: .*$/).first.split(":")[1].strip.gsub!(/\./, '-')
      replaced_data = replace_tokens(data, @request_id)

      redis.hset(@request_id, :url, url)
      redis.hset(@request_id, :verb, verb)
      redis.hset(@request_id, :time, Time.now.ctime)
      redis.hset(@request_id, :production_request, data)
      redis.hset(@request_id, :shadow_request, replaced_data)
      {:shadow => replaced_data, :production => data}
    else
      puts "Bucardo is down, skipping request."
      data
    end
  end

  conn.on_response do |server, resp|
    @data[server] += resp
    resp if server == :production
  end

  conn.on_finish do |name|
    p [:on_finish, name, Time.now - @start]

    if @request_id
      puts "Saving request to redis."
      redis.hset(@request_id, :production, @data[:production])
      redis.hset(@request_id, :shadow, @data[:shadow])
      redis.hset(@request_id, :commit_hash, redis.get("commit_hash"))
    else
      puts "Finished ignored request."
    end

    if name == :shadow
      detect_tokens(@data[:shadow], @request_id)
    end
    :close if name == :production

    if @bucardo_stopped && redis.get('bucardo_working').to_s != "true"
      #puts "Finished non-idempotent request, reseting bucardo."
      #BucardoResetWorker.perform_async
    end
  end
end