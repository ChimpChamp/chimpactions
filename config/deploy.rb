default_run_options[:pty] = true
set :use_sudo, false 
set :ssh_options, {:forward_agent => true}
on :start do    
  #`ssh-add`
end
set :runner, 'deploy'
set :admin_runner, 'deploy'
set :stages, %w(dev production)
set :default_stage, "dev"
require 'capistrano/ext/multistage'

set :scm, :git
set :repository, "git@c_git:chimpactions.git"
set :deploy_via, :remote_cache

set :user, 'deploy'
set :ssh_options, { :forward_agent => true }
 
role :app, "c_git"
role :web, "c_git"
role :db,  "c_git", :primary => true

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do ;end
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   after "deploy:update_code", :link_production_db
   
   end
   
       # database.yml task
    desc "Link in the production database.yml"
    task :link_production_db do
      run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/test/dummy/config/database.yml"
      run "ln -nfs #{deploy_to}/shared/db #{release_path}/test/dummy/db"
    end