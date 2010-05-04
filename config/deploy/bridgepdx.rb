set :scm, "git"
set :branch, "master" unless variables[:branch]
set :repository,  "git://github.com/igal/compticketeer.git"
set :deploy_to, "/var/www/bridgepdx_compticketeer"
set :host, "opensourcebridge.org"
set :user, "bridgepdx"

set :deploy_via, :remote_cache
role :app, host
role :web, host
role :db,  host, :primary => true
default_run_options[:pty] = true
