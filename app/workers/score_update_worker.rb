class ScoreUpdateWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
  end

  def perform
        Commit.last.update_scores
  end

end
