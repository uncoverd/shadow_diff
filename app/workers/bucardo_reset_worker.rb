class BucardoResetWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def initialize
  end

  def perform
    redis = Redis.new(:host => "127.0.0.1", :port => 6379, :db => 0)
    redis.set("bucardo_working", "true")

    #ENV['MASTER_DB'] ENV['SLAVE_DB']
    controller = BucardoController.new('128.199.59.160','188.166.15.157')
    controller.reset_slave_db
    redis.set("bucardo_working", "false")
    redis.set("bucardo_active", "true")
  end

end
