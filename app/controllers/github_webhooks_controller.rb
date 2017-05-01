class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def github_pull_request(payload)
    if payload['action'] == 'labeled' && payload['label']['name'] == 'duplicate'
      puts "Starting proxy"
    elsif payload['action'] == 'unlabeled' && payload['label']['name'] == 'duplicate'
      puts "Stopping proxy"
    end    
  end

  def webhook_secret(payload)
    #ENV['GITHUB_WEBHOOK_SECRET']
    "hunter2"
  end
end