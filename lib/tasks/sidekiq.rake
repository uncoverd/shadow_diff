SIDEKIQ_PID = File.expand_path("../../../tmp/pids/sidekiq.pid", __FILE__)

namespace :sidekiq do
  def sidekiq_is_running?
    File.exists?(SIDEKIQ_PID) && system("ps x | grep `cat #{SIDEKIQ_PID}` 2>&1 > /dev/null")
  end

  desc "Start sidekiq daemon for development."
  task :start => :stop do
    if sidekiq_is_running?
      puts "Sidekiq is already running."
    else
      sh "bundle exec sidekiq -e production -d" # -d means daemon
    end
  end
  #desc "Start sidekiq daemon for staging."
  #task :start_staging => :stop do
  #  if sidekiq_is_running?
  #    puts "Sidekiq is already running."
  #  else
  #    sh "bundle exec sidekiq -e staging -d" # -d means daemon
  #  end
  #end

  desc "Stop sidekiq daemon."
  task :stop do
    if File.exists? SIDEKIQ_PID
      sh "sidekiqctl stop #{SIDEKIQ_PID}"
    end
  end

  desc "Show status of sidekiq daemon."
  task :status do
    if sidekiq_is_running?
      puts "Sidekiq is running"
    else
      puts "Sidekiq is stopped"
    end
  end
end