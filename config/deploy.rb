set :application, "music"
default_run_options[:pty] = true
set :repository,  "git@github.com:cketcham/music.git"

set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"

set :scm, "git"
set :branch, "master"

set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache

ssh_options[:paranoid] = false

set :user, 'mongrel'
set :runner, 'mongrel'
set :use_sudo, false

role :app, "jump.ath.cx"
role :web, "jump.ath.cx"
role :db,  "jump.ath.cx", :primary => true

#moves over server config files after deploying the code
task :update_config, :roles => [:app] do
  run "cp -rf #{shared_path}/config/* #{release_path}/config"
  run "ln -s #{shared_path}/files #{release_path}/public/files"
end
after 'deploy:update_code', :update_config