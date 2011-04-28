# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.10' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Specify gems that this application depends on and have them installed with rake gems:install
  config.gem 'aasm', :version => '2.2.0'
  config.gem 'authlogic', :version => '2.1.6'
  config.gem 'super_exception_notifier', :version => '~> 2.0.8', :lib => 'exception_notifier'
  config.gem 'json', :version => '1.5.1'

  if ['development', 'test'].include? RAILS_ENV
    config.gem 'factory_girl', :version => '1.3.3', :lib => false
    config.gem 'rspec-rails',  :version => '1.3.3', :lib => false
  end

  # Libraries
  require 'digest/md5'

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # Load custom libraries before "config/initializers" run.
  $LOAD_PATH.unshift("#{RAILS_ROOT}/lib")
end
