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
    pid = Process.spawn("ruby #{Rails.root.join('em_proxy.rb')}")
    REDIS.with do |conn|
      conn.set("proxy_PID", pid)
    end
  end

  def end_proxy
    REDIS.with do |conn|
      Process.kill("TERM", conn.get("proxy_PID"))
    end
  end    
end