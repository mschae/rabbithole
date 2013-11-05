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

  config.before :all do
    # Create test vhost
    request = Net::HTTP::Put.new('/api/vhosts/%2Frabbithole-test', 'Content-Type' => 'application/json')
    request.basic_auth Rabbithole::Connection::Settings.user, Rabbithole::Connection::Settings.password
    Net::HTTP.new(Rabbithole::Connection::Settings.host, Rabbithole::Connection::Settings.port + 10000).start {|http| http.request(request) }

    # Grant permission on test vhost
    request = Net::HTTP::Put.new('/api/permissions/%2Frabbithole-test/guest', 'Content-Type' => 'application/json')
    request.basic_auth Rabbithole::Connection::Settings.user, Rabbithole::Connection::Settings.password
    request.body = '{"configure":".*","write":".*","read":".*"}'
    Net::HTTP.new(Rabbithole::Connection::Settings.host, Rabbithole::Connection::Settings.port + 10000).start {|http| http.request(request) }
  end

  config.after :all do
    # Delete test vhost
    request = Net::HTTP::Delete.new('/api/vhosts/%2Frabbithole-test', 'Content-Type' => 'application/json')
    request.basic_auth Rabbithole::Connection::Settings.user, Rabbithole::Connection::Settings.password
    Net::HTTP.new(Rabbithole::Connection::Settings.host, Rabbithole::Connection::Settings.port + 10000).start {|http| http.request(request) }
  end
end
