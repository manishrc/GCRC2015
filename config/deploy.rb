set :repository,  "https://github.com/GardenCityRuby/GCRC2015.git"
set :scm,         :git
set :branch,      "master"
set :deploy_via,  :remote_cache
set :scm_verbose, true
set :use_sudo,    true
set :user, ENV["DEPLOY_USER"]
set :deploy_to,   ENV["DEPLOY_DIR"]
set :domain, ENV["DEPLOY_DOMAIN"]
set :port, ENV["DEPLOY_PORT"]


set :ssh_options, forward_agent: true


server ENV["DEPLOY_DOMAIN"], :app, :web, :db, :primary => true

after "deploy:setup", "deploy:fix_permissions"

namespace :deploy do
  desc "Fix permissions"
  task :fix_permissions, :roles => :app do
    sudo "chown -R #{user}:#{user} #{deploy_to}"
  end
end

after "deploy:create_symlink", "gcrc:compile"

namespace :gcrc do
  desc "Compile the content on Server"
  task :compile, :roles => :app do
    run "cd #{current_path} && bundle install"
    run "cd #{current_path} && bundle exec jekyll build --destination _site --config _config.yml,_config_deploy.yml"
  end
end


