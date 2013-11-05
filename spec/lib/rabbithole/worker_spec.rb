require 'spec_helper'

describe Rabbithole::Worker do
  it 'let\'s me subscribe to queues' do
    expect {
      subject.listen_to_queue(Rabbithole::Connection::DEFAULT_QUEUE)
      wait_for { Rabbithole::Connection.default_queue.consumer_count > 0 }
    }.to change {Rabbithole::Connection.default_queue.consumer_count}.by(1)
    subject.stop_listening
  end

  it 'invokes the perform action' do
    class FooJob
      def self.perform; end
    end
    FooJob.should_receive(:perform).once
    Rabbithole.enqueue(FooJob)
    subject.listen_to_queue(Rabbithole::Connection::DEFAULT_QUEUE)
    wait_for { Rabbithole::Connection.default_queue.message_count > 0 }
    subject.stop_listening
  end

end
