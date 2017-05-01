class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def github_pull_request(payload)
    proxy = DuplexProxy.new
    if payload['action'] == 'labeled' && payload['label']['name'] == 'duplicate'
      proxy.start
    elsif payload['action'] == 'unlabeled' && payload['label']['name'] == 'duplicate'
      proxy.stop
    end    
  end

  def webhook_secret(payload)
    "hunter2"
  end

end