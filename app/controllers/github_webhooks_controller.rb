class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def github_pull_request(payload)
      puts payload
  end    

  def webhook_secret(payload)
    #ENV['GITHUB_WEBHOOK_SECRET']
    "hunter2"
  end
end