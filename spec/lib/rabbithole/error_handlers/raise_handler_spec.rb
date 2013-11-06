require 'spec_helper'

describe Rabbithole::ErrorHandlers::RaiseHandler do
  let(:worker){ Rabbithole::Worker.new }
  before :each do
    worker.listen_to_queue(Rabbithole::Connection::DEFAULT_QUEUE)
    Rabbithole::ErrorHandler.register_handler described_class
  end

  after :each do
    worker.stop_listening
  end

  it 'should raise errors' do
    class RaiseHandlerTestjob
      def self.perform
        raise 'hell'
      end
    end

    expect {
      Rabbithole.enqueue(RaiseHandlerTestjob)
      sleep 0.5
    }.to raise_error
    Rabbithole::Connection.default_queue.message_count.should == 0
  end
end
