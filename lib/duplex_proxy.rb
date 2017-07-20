class DuplexProxy

  def start(repo, commit, author, title, url)
    puts "STARTING PROXY"
    active_commit = Commit.find_or_create_by(commit_hash: commit)
    active_commit.description = title
    active_commit.commit_url = url
    active_commit.repo = repo
    active_commit.save
    REDIS.with do |conn|
      conn.set("commit_hash", active_commit.commit_hash)
    end  
    puts repo
    puts commit
    puts author
    spawn_proxy
    GithubNotifier.new(active_commit)
  end

  def stop(repo, commit)
    puts "STOPING PROXY"
    kill_proxy
    active_commit = Commit.find_by(commit_hash: commit)
    GithubNotifier.new(active_commit)
  end

  private

  def spawn_proxy
    REDIS.with do |conn|
      if conn.get("proxy_PID").to_i == 0
        pid = Process.spawn("bundle exec ruby #{Rails.root.join('em_proxy.rb')}")
        Process.detach(pid)
        conn.set("proxy_PID", pid)
      else
        puts "Already running"  
      end  
    end
  end  

  def kill_proxy
    REDIS.with do |conn|
      begin
        Process.kill("TERM", conn.get("proxy_PID").to_i)
      rescue Errno::ESRCH
      end    
      conn.set("proxy_PID", "0")
    end
  end  
end    