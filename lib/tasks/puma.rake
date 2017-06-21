PUMA_PID = File.expand_path("../../../tmp/pids/puma.pid", __FILE__)

namespace :puma do

  desc "start Puma server"
  task :start => :environment do
    if puma_is_running?
      raise "Puma is already running"
    else
      puts "Puma is starting"
      system 'RACK_ENV=production pumactl start'
    end
  end

  desc "phase restart puma"
  task :phase_restart => :environment do
    if puma_is_running?
      puts "Puma is phase restarting"
      system 'RACK_ENV=production pumactl -P tmp/pids/puma.pid phased-restart'
    else
      Rake::Task["puma:start"].invoke
    end
  end
  desc "stop Puma server"
  task :stop => :environment do
    if puma_is_running?
      puts "Puma is stopping"
      system 'RACK_ENV=production pumactl -P tmp/pids/puma.pid stop'
    end
  end

  desc "show Puma status"
  task :status => :environment do
    if puma_is_running?
      puts "Puma is running"
    else
      puts "Puma is stopped"
    end
  end

  def puma_is_running?
    File.exists?(PUMA_PID) && system("ps -p `cat #{PUMA_PID}` 2>&1 > /dev/null")
  end

end