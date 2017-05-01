class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def github_pull_request(payload)
    if payload['action'] == 'labeled' && payload['label']['name'] == 'duplicate'
      puts "Starting proxy"
      start_proxy
    elsif payload['action'] == 'unlabeled' && payload['label']['name'] == 'duplicate'
      puts "Stopping proxy"
      end_proxy
    end    
  end

  def webhook_secret(payload)
    "hunter2"
  end

  private

  def start_proxy
    REDIS.with do |conn|
      if conn.get("proxy_PID") == "0"
        pid = Process.spawn("ruby #{Rails.root.join('em_proxy.rb')}")
        conn.set("proxy_PID", pid)
      else
        puts "Already running"  
      end  
    end
  end

  def end_proxy
    REDIS.with do |conn|
      Process.kill("TERM", conn.get("proxy_PID").to_i)
      conn.set("proxy_PID", "0")
    end
  end    
end