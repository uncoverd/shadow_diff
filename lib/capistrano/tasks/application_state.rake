desc "Restart application server"
task :restart_application do
  restart_puma
end

desc "Phase restart application server"
task :phase_restart_application do
  phase_restart_puma
end

desc "Restart sidekiq workers"
task :restart_workers do
  restart_sidekiq
end


def restart_puma
  on roles(:app) do
    within "#{fetch(:deploy_to)}/current/" do
      with RAILS_ENV: fetch(:environment) do
        execute :rake, "puma:stop"
        execute :rake, "puma:start"
      end
    end
  end
end

def phase_restart_puma
  on roles(:app) do
    within "#{fetch(:deploy_to)}/current/" do
      with RAILS_ENV: fetch(:environment) do
        execute :rake, "puma:phase_restart"
      end
    end
  end
end

def restart_sidekiq
  sidekiq_env = {RAILS_ENV: fetch(:environment)}
  if environment_is? 'staging'
    sidekiq_env['STAGING'] = 'true'
  end
  on roles(:app) do
    within "#{fetch(:deploy_to)}/current/" do
      with sidekiq_env do
        execute :rake, "sidekiq:stop"
        clear_sidekiq_jobs
        execute :rake, "sidekiq:start"
      end
    end
  end
end

def clear_sidekiq_jobs
   ['sidetiq:*', 'schedule'].each do |pattern|
     execute "redis-cli keys #{pattern} | xargs redis-cli del"
   end
end


def start_application
  within "#{fetch(:deploy_to)}/current/" do
    with RAILS_ENV: fetch(:environment) do
      execute :rake, "puma:start"
      execute :rake, "sidekiq:start"
    end
  end
end
