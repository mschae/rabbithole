require 'spec_helper'

describe Rabbithole::Worker do
  before :each do
    subject.listen_to_queue(Rabbithole::Connection::DEFAULT_QUEUE)
  end

  after :each do
    subject.stop_listening
  end

  it 'invokes the perform action' do
    class InvokeTestJob
      def self.perform; end
    end

    InvokeTestJob.should_receive(:perform)
    Rabbithole.enqueue(InvokeTestJob)
    sleep 0.5
  end

  it 'passes the correct arguments to the perform action' do
    class ArgumentsTestJob
      def self.perform(arg1, arg2); end
    end

    ArgumentsTestJob.should_receive(:perform).with(1, 'a').once
    Rabbithole.enqueue(ArgumentsTestJob, 1, 'a')
    sleep 1
  end

  it 'gracefully handles failing jobs' do
    class HandlingFailsJob
      def self.perform
        raise 'hell'
      end
    end

    Rabbithole::ErrorHandler.should_receive(:handle).twice
    Rabbithole.enqueue(HandlingFailsJob)
    sleep 0.5
  end
end
