# config valid only for Capistrano 3.1
lock '3.2.1'

set :domain, "collabrite.com"
set :repo_url, "git@github.com:ask4prasath/brimir_clone.git"

set :scm, :git
set :deploy_via, :remote_cache
set :branch, "master"
set :default_stage, "production"

set :use_sudo, false
set :keep_releases, 3

set :deploy_to, "/home/deploy/brimir"
set :application_path, "/home/deploy/brimir"
set :rails_env, "development"
set :stage, "development"

role :app, "collabrite.com"
role :db, "collabrite.com", :primary => true

set :port, 22

#after 'deploy:update', 'deploy:restart'
#before 'deploy:migrate', 'deploy:bundle'

#namespace :deploy do
#
#  task :restart, :roles => :app, :except => { :no_release => true } do
#    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#  end
#
#  after :publishing, :restart
#end