module Rabbithole
  class Worker
    attr_reader :number_of_threads

    def initialize(number_of_threads = 1)
      @number_of_threads = number_of_threads
      @channel           = Connection.create_channel(number_of_threads)
      @channel.prefetch(number_of_threads * 5)
    end

    def listen_to_queue(queue_name)
      queue   = Connection.queue(queue_name, @channel)
      start_consumer(queue)
    end

    def stop_listening
      @channel.consumers.values.each(&:cancel)
    end

    def join
      @channel.work_pool.join
    end

    private
    def start_consumer(queue)
      queue.subscribe(:ack => true, :block => false) do |delivery_info, properties, payload|
        data = MessagePack.unpack(payload)
        begin
          Object.const_get(data['klass']).perform(*data['args'])
          @channel.acknowledge(delivery_info.delivery_tag, false)
        rescue => e
          @channel.reject(delivery_info.delivery_tag, !delivery_info.redelivered)
          ErrorHandler.handle(e, queue.name, payload)
        end
      end
    end
  end
end

