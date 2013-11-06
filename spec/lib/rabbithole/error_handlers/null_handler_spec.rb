require 'spec_helper'

describe Rabbithole::ErrorHandlers::NullHandler do
  let(:worker){ Rabbithole::Worker.new }
  before :each do
    worker.listen_to_queue(Rabbithole::Connection::DEFAULT_QUEUE)
    Rabbithole::ErrorHandler.register_handler described_class
  end

  after :each do
    worker.stop_listening
  end

  it 'does absolutely nothing on errors' do
    class BazJob
      def self.perform
        raise 'hell'
      end
    end

    Rabbithole.enqueue(BazJob)
    wait_for { Rabbithole::Connection.default_queue.message_count > 0 }
    wait_for { Rabbithole::Connection.default_queue.message_count == 0 }
  end
end
