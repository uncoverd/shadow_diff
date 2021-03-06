class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def github_pull_request(payload)
    proxy = DuplexProxy.new
    repo_name = payload['pull_request']['head']['repo']['full_name']
    commit_hash = payload['pull_request']['head']['sha']
    author = payload['pull_request']['user']['login']
    title = payload['pull_request']['title']
    url = payload['pull_request']['html_url']
    puts repo_name
    puts commit_hash
    
    if pull_request_labeled(payload)
      proxy.start(repo_name, commit_hash, author, title, url)
    elsif pull_request_unlabeled(payload)
      proxy.stop(repo_name, commit_hash)
    end    
  end

  def webhook_secret(payload)
    "hunter2"
  end

  private

  def pull_request_labeled(payload)
    payload['action'] == 'labeled' && payload['label']['name'] == 'duplicate'
  end

  def pull_request_unlabeled(payload)
    payload['action'] == 'unlabeled' && payload['label']['name'] == 'duplicate'
  end  
end