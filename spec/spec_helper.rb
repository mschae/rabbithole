unless ENV['CI']
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'

ROOT = Pathname.new(__FILE__).dirname.join('..')
require_relative ROOT.join('lib', 'rabbithole')
require 'net/http'

Dir[ROOT.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec

  config.before :suite do
    # Create test vhost
    %x{
      sudo rabbitmqctl add_vhost #{Rabbithole::Connection::Settings.vhost}
      sudo rabbitmqctl add_user #{Rabbithole::Connection::Settings.user} #{Rabbithole::Connection::Settings.password}
      sudo rabbitmqctl set_permissions -p #{Rabbithole::Connection::Settings.vhost} #{Rabbithole::Connection::Settings.user} ".*" ".*" ".*"
    }
  end

  config.after :suite do
    %x{
      sudo rabbitmqctl delete_vhost #{Rabbithole::Connection::Settings.vhost}
      sudo rabbitmqctl delete_user #{Rabbithole::Connection::Settings.user}
    }
  end
end
