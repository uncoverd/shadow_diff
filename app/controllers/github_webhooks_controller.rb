class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def github_pull_request(payload)
    if payload['label']['name'] == 'duplicate'
        puts "Starting proxy"
    else
        puts "Stopping proxy"
    end    
  end    

  def webhook_secret(payload)
    #ENV['GITHUB_WEBHOOK_SECRET']
    "hunter2"
  end
end