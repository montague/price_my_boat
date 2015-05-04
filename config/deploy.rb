set :application, 'boat_valuator'
set :repo_url, 'git@github.com:montague/boat_valuator'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, "/home/deploy/apps/#{fetch :application}"
#set :scm, :git

set :format, :pretty
# set :log_level, :debug
#set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 4


namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
       execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  #after :restart, :clear_cache do
    #on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    #end
  #end

  after :finishing, 'deploy:cleanup'

  desc 'upload nginx conf and create cap directories'
  task :bootstrap do
    # 1) run playbook
    # 2) run bootstrap
    # 3) upload database.yml to shared/config
    # 4) deploy
    erb = File.read(File.expand_path('../deploy/templates/vhost.erb', __FILE__))
    application = fetch :application
    nginx_conf_dir = "/etc/nginx/sites-available"
    on roles(:app) do |host|
      # TODO make shit run from /home/deploy/apps/[application]
      upload! StringIO.new(ERB.new(erb).result), "/tmp/#{application}"
      sudo "mv /tmp/#{application} #{nginx_conf_dir}"
      execute "chmod +x #{nginx_conf_dir}/#{application}"
      sudo "ln -s #{nginx_conf_dir}/#{application} /etc/nginx/sites-enabled"
      sudo "mkdir -p #{deploy_to}/shared/{config,bundle,log}"
      sudo "chown -R deploy #{deploy_to}"
      sudo "service nginx restart"
    end
  end
end

