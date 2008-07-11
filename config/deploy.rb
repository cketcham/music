set :application, "music"
set :repository,  "git@github.com:cketcham/music.git"
set :domain, "music.jump.ath.cx"

set :mongrel_conf, "${current_path}/config/mongrel_cluser.yml"

set :scm, "git"
set :branch, "origin/master"
set :deploy_via, :remote_cache

ssh_options[:paranoid] = false

set :user, 'mongrel'
set :runner, 'mongrel'
set :use_sudo, false

role :app, "jump.ath.cx"
role :web, "music.jump.ath.cx"
role :db,  "jump.ath.cx", :primary => true

task :updaet_config, :roles => [:app] do
  run "cp -rf #{shared_path}/config/* #{release_path}/config"
end
after 'deploy:update_code', :update_config