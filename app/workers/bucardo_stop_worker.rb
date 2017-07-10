class BucardoStopWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
  end

  def perform
    redis = Redis.new(:host => "127.0.0.1", :port => 6379, :db => 0)
    #ENV['MASTER_DB'] ENV['SLAVE_DB']
    controller = BucardoController.new('128.199.59.160','188.166.15.157')
    controller.stop_master_sync
  end

end
