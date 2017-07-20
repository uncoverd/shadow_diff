class ScoreUpdateWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
  end

  def perform
      active_commit = Commit.last
      active_commit.update_scores
      GithubNotifier.new(active_commit)
  end

end
