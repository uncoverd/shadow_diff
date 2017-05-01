class DuplexProxy
  
  def start
    puts "STARTING PROXY"
    spawn_proxy
  end

  def stop
    puts "STOPING PROXY"
    kill_proxy
  end

  private

  def spawn_proxy
    REDIS.with do |conn|
      if conn.get("proxy_PID") == "0"
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