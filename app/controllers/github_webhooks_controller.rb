class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def github_pull_request(payload)
    proxy = DuplexProxy.new
    if payload['action'] == 'labeled' && payload['label']['name'] == 'duplicate'
      proxy.start(payload['head']['repo']['full_name'], payload['head']['sha'])
    elsif payload['action'] == 'unlabeled' && payload['label']['name'] == 'duplicate'
      proxy.stop
    end    
  end

  def webhook_secret(payload)
    "hunter2"
  end

end