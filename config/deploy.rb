# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'quotatious'
set :repo_url, 'git@github.com:Quotatious/core.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :bundle_bins, %w{gem rake rails puma pumactl}
set :rvm_map_bins, %w{gem rake ruby bundle  puma pumactl}

namespace :deploy do

  desc 'Configuration'
  task :configuration do
    on roles(:app), in: :sequence, wait: 5 do
      if test("[ ! -f #{shared_path}/secrets.yml ]")
        execute "cp #{release_path}/config/secrets.yml.dist #{shared_path}/secrets.yml"
      end

      if test("[ ! -f #{shared_path}/mongoid.yml ]")
        execute "cp #{release_path}/config/mongoid.yml.dist #{shared_path}/mongoid.yml"
      end

      execute "ln -s #{shared_path}/secrets.yml #{release_path}/config/secrets.yml"
      execute "ln -s #{shared_path}/mongoid.yml #{release_path}/config/mongoid.yml"
    end
  end
  after :updated, :configuration

  desc "Start the application"
  task :start do
    on roles(:app) do
      within release_path do
        execute :puma, "-b", "unix://#{shared_path}/puma.sock", "-d", "-e", "#{fetch(:stage)}", "-S", "#{shared_path}/puma.state"
      end
    end
  end

  desc "Stop the application"
  task :stop do
    on roles(:app) do
      within release_path do
        execute :pumactl, "-S", "#{shared_path}/puma.state", "stop"
      end
    end
  end

  desc "Restart the application"
  task :restart do
    on roles(:app) do
      within release_path do
        execute :pumactl, "-S", "#{shared_path}/puma.state", "restart"
      end
    end
  end

  after :publishing, :restart

  desc "Status of the application"
  task :status do
    on roles(:app) do
      within release_path do
        execute :pumactl, "-S", "#{shared_path}/puma.state", "stats"
      end
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within release_path do
         execute :rake, 'db:mongoid:create_indexes'
       end
    end
  end
end
