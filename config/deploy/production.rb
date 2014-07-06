set :stage, :production
set :branch, "master"

server 'collabrite.com', user: 'deploy', roles: %w{web app}, my_property: :my_value


#set :application, "brimir.collabrite.com"
#set :domain, application
#set :repository, "git@github.com:ask4prasath/brimir_clone.git"