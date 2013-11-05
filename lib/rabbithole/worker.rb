module Rabbithole
  class Worker
    attr_reader :number_of_threads

    def initialize(number_of_threads = 1)
      @number_of_threads = number_of_threads
      @threads           = []
    end

    def listen_to_queue(queue_name)
      channel = Connection.create_channel(number_of_threads)
      queue = Connection.queue(queue_name, channel)

      @threads << queue.subscribe(:ack => true, :block => false) do |delivery_info, properties, payload|
        data = MultiJson.load(payload)
        begin
          Object.const_get(data['klass']).perform
          channel.acknowledge(delivery_info.delivery_tag, false)
        rescue => e
          handle_error(e)
        end
      end
    end

    def stop_listening
      @threads.each(&:cancel)
    end

    def handle_error(error)

    end
  end
end

