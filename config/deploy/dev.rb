# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.    
require "rvm/capistrano"

set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user  # Don't use system-wide RVM

set :branch, "develop"
set :application, "chimpactions"
set :deploy_to, "/home/deploy/apps/deployed/chimpactions"
set :link_path, "/home/deploy/apps"

namespace :deploy do
  
  task :symlink, :except => { :no_release => true } do
    link_path = "/home/deploy/apps/#{application}"
    on_rollback do
      if previous_release
        run "rm -f #{link_path}; ln -s #{previous_release} #{link_path}; true"
      else
        logger.important "no previous release to rollback to, rollback of symlink skipped"
      end
    end

    run "rm -f #{link_path} && ln -s #{latest_release} #{link_path}"
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
  #  run "cd #{release_path}/test/dummy && rvm use rails3 && bundle install"
    run "/sbin/service tst2 restart #{application}"
  end
  
end