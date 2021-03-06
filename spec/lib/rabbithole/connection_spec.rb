require 'spec_helper'

describe Rabbithole::Connection do
  describe Rabbithole::Connection::Settings do
    it 'reads the correct config' do
      Rabbithole::Connection::Settings.host.should == 'localhost'
      Rabbithole::Connection::Settings.port.should == 5672
      Rabbithole::Connection::Settings.vhost.should == '/rabbithole-test'
      Rabbithole::Connection::Settings.user.should == 'rabbithole-test-user'
      Rabbithole::Connection::Settings.password.should == 'rabbithole-test-password'
    end

    it '#to_url' do
      Rabbithole::Connection::Settings.to_url.should == 'amqp://rabbithole-test-user:rabbithole-test-password@localhost:5672/%2Frabbithole-test'
    end
  end

  it 'establishes a connection' do
    described_class.session
  end

end
