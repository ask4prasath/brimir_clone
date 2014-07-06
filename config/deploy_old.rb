require "rvm/capistrano"
require "bundler/capistrano"     # Load RVM's capistrano plugin.

set :application, "brimir.collabrite.com"
set :domain, application
set :repository, "git@github.com:ask4prasath/brimir_clone.git"

set :scm, :git

set :user, 'deploy'

set :deploy_via, :remote_cache
set :branch, "master"
set :default_stage, "production"

set :use_sudo, false
set :keep_releases, 5

set :deploy_to, "/home/deploy/brimir"
set :application_path, "/home/deploy/brimir"
set :rails_env, "development"

role :app, application
role :db, application, :primary => true

set :port, 22

after 'deploy:update', 'deploy:restart'
                                 #before 'deploy:migrate', 'deploy:bundle'

namespace :deploy do

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end