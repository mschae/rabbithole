require 'spec_helper'

describe Rabbithole do
  it 'enqueues defined jobs' do
    class FooJob
      def self.perform(*args); end
    end

    expect {
      described_class.enqueue(FooJob)
      wait_for { Rabbithole::Connection.default_queue.message_count > 0 }
    }.to change { Rabbithole::Connection.default_queue.message_count }.by 1
    Rabbithole::Connection.default_queue.pop
  end

  it 'fails to enqueue a job that does not define a perform method' do
    class BazClass
    end

    expect { described_class.enqueue(BazClass) }.to raise_error Rabbithole::InvalidJobError
    Rabbithole::Connection.default_queue.message_count.should == 0
  end

  context 'queues' do
    it 'allows to specify a queue' do
      class BarJob
        @queue = 'barqueue'
        def self.perform; end
      end

      expect {
        Rabbithole.enqueue(BarJob)
        wait_for { Rabbithole::Connection.queue('barqueue').message_count > 0 }
      }.to change {Rabbithole::Connection.queue('barqueue').message_count}.by 1

      expect {
        Rabbithole.enqueue(BarJob)
        wait_for { Rabbithole::Connection.queue('barqueue').message_count > 0 }
      }.not_to change {Rabbithole::Connection.default_queue}

    end
  end
end
