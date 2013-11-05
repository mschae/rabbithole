require 'spec_helper'

describe Rabbithole::Worker do
  before :each do
    subject.listen_to_queue(Rabbithole::Connection::DEFAULT_QUEUE)
  end

  after :each do
    subject.stop_listening
  end

  it 'invokes the perform action' do
    class FooJob
      def self.perform; end
    end

    FooJob.should_receive(:perform).once
    Rabbithole.enqueue(FooJob)
    wait_for { Rabbithole::Connection.default_queue.message_count > 0 }
  end

  it 'passes the correct arguments to the perform action' do
    class BarJob
      def self.perform(arg1, arg2); end
    end

    BarJob.should_receive(:perform).with(1, 'a').once
    Rabbithole.enqueue(BarJob, 1, 'a')
    wait_for { Rabbithole::Connection.default_queue.message_count > 0 }
  end

  it 'gracefully handles failing jobs' do
    class BazJob
      def self.perform
        raise 'hell'
      end
    end

    subject.should_receive(:handle_error).twice
    Rabbithole.enqueue(BazJob)
    wait_for { Rabbithole::Connection.default_queue.message_count > 0 }
  end

end
