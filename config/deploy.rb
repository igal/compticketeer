#===[ Setup ]===========================================================

begin
  require 'bundler/capistrano'
rescue LoadError
  puts <<-HERE
    ERROR: You must install `bundler` on this computer to do deployments, e.g.:
    % sudo gem install bundler
  HERE
end

#===[ General settings ]================================================

set :application, "compticketeer"
set :use_sudo, false
ssh_options[:compression] = false
default_run_options[:pty] = true

#===[ Deploy tasks ]====================================================

# Restart for Phusion Passenger:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Upload configuration files"
  task :configs, :roles => :app do
    top.upload "config/database.yml", "#{shared_path}/config/database.yml"
    top.upload "config/secrets.yml",  "#{shared_path}/config/secrets.yml"
  end
end

desc "Symlink configuration files"
task :symlink_configs, :roles => :app do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/"
  run "ln -nfs #{shared_path}/config/secrets.yml  #{release_path}/config/"
end

# Callbacks:
before 'deploy:finalize_update', :symlink_configs

#===[ Database tasks ]==================================================

namespace :db do
  desc "Download remote 'production' database and replace existing 'development' database with it."
  task :use, :roles => :db, :only => {:primary => true} do
    # NOTE: This assumes that both development and production are using SQLite3 databases.
    source = "#{user}@#{host}:#{shared_path}/db/production.sqlite3"
    target = "db/development.sqlite3"
    backup = target + '.bak'

    sh "cp -a #{target} #{backup}" if File.exist?(target)
    sh "rsync -uvax #{source} #{target}"
  end
end

#===[ Utilities ]=======================================================

# Print the command and then execute it, just like Rake.
def sh(command)
  puts command
  system command unless dry_run
end

#===[ fin ]=============================================================
