unless ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'

ROOT = Pathname.new(__FILE__).dirname.join('..')
require ROOT.join('lib', 'rabbithole')
require 'net/http'

Dir[ROOT.join("spec/support/**/*.rb")].each {|f| require f}

RABBITCTL_COMMAND = ENV['TRAVIS'] ? 'sudo rabbitmqctl' : 'rabbitmqctl'

RSpec.configure do |config|
  config.mock_with :rspec

  config.before :suite do
    # Create test vhost
    %x{
      #{RABBITCTL_COMMAND} add_vhost #{Rabbithole::Connection::Settings.vhost}
      #{RABBITCTL_COMMAND} add_user #{Rabbithole::Connection::Settings.user} #{Rabbithole::Connection::Settings.password}
      #{RABBITCTL_COMMAND} set_permissions -p #{Rabbithole::Connection::Settings.vhost} #{Rabbithole::Connection::Settings.user} ".*" ".*" ".*"
    }
  end

  config.after :suite do
    %x{
      #{RABBITCTL_COMMAND} delete_vhost #{Rabbithole::Connection::Settings.vhost}
      #{RABBITCTL_COMMAND} delete_user #{Rabbithole::Connection::Settings.user}
    }
  end
end
