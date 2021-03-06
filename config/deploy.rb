# config valid only for current version of Capistrano
lock "3.8.2"

set :application, "shadow_diff"
set :repo_url, "git@github.com:uncoverd/shadow_diff.git"

set :deploy_user, 'deploy'
set :deploy_to, "/home/#{fetch(:deploy_user)}/#{fetch(:application)}"
set :tmp_dir, "/home/#{fetch(:deploy_user)}/tmp"

set :pty, true

set :format, :pretty
set :linked_files, %w{ config/database.yml}
set :linked_dirs, %w{ log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :bundle_binstubs, nil
set :ssh_options, { :forward_agent => true }

after :deploy, :phase_restart_application
after :deploy, :restart_workers




# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5
