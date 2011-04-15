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
    run "/sbin/service tst2 restart #{application}"
  end
  
end