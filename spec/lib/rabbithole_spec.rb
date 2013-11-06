require 'spec_helper'

describe Rabbithole do
  it 'enqueues well defined jobs' do
    class FooJob
      def self.perform(*args); end
    end

    expect {
      described_class.enqueue(FooJob)
    }.to change { Rabbithole::Connection.default_queue.message_count }.by 1
  end

  it 'fails to enqueue a job that does not define a perform method' do
    class BazClass
    end

    expect do
      expect { described_class.enqueue(BazClass) }.to raise_error Rabbithole::InvalidJobError
    end.to_not change {Rabbithole::Connection.default_queue.message_count }
  end

  context 'queues' do
    it 'allows to specify a queue' do
      class BarJob
        @queue = 'barqueue'
        def self.perform; end
      end

      expect {
        Rabbithole.enqueue(BarJob)
      }.to change {Rabbithole::Connection.queue('barqueue').message_count}.by 1
      Rabbithole::Connection.queue('barqueue').pop

      expect {
        Rabbithole.enqueue(BarJob)
      }.not_to change {Rabbithole::Connection.default_queue}
      Rabbithole::Connection.queue('barqueue').pop
    end
  end
end
