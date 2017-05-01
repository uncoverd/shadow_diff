class DuplexProxy

  MESSAGES = {
    'sucess': 'passed',
    'pending': 'in progress',
    'failure': 'failed',
    'error': 'error'
  }

  def start(repo, commit)
    puts "STARTING PROXY"
    spawn_proxy
    notify_github(repo, commit, 'pending')
  end

  def stop(repo, commit)
    puts "STOPING PROXY"
    kill_proxy
    notify_github(repo, commit, 'failure')
  end

  private

  def notify_github(repo, commit, status)
    Octokit.create_status(repo, commit, status,
                          :context => 'Request shadowing',
                          :description => MESSAGES[status])
  end

  def spawn_proxy
    REDIS.with do |conn|
      if conn.get("proxy_PID").to_i == 0
        pid = Process.spawn("ruby #{Rails.root.join('em_proxy.rb')}")
        conn.set("proxy_PID", pid)
      else
        puts "Already running"  
      end  
    end
  end  

  def kill_proxy
    REDIS.with do |conn|
      Process.kill("TERM", conn.get("proxy_PID").to_i)
      conn.set("proxy_PID", "0")
    end
  end  
end    