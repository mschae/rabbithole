require 'settingslogic'
require 'bunny'

module Rabbithole
  class Connection
    QUEUE_PREFIX  = "rabbithole/#{Rails.application.class.parent_name.downcase}"
    DEFAULT_QUEUE = 'default_queue'

    class << self
      def publish(queue_name, payload)
        channel = create_channel
        queue(queue_name)
        channel.default_exchange.publish(payload, :routing_key => get_queue_name(queue_name))
        channel.close
      end

      def default_queue
        queue DEFAULT_QUEUE
      end

      def get_queue_name(queue)
        "#{QUEUE_PREFIX}.#{queue}"
      end

      def queue(name, channel = self.channel)
        channel.queue(get_queue_name(name), :durable => true)
      end

      def session
        @connection ||=
          begin
            connection = Bunny.new(configuration)
            connection.start
          end
      end

      def create_channel(worker_pool_size = 1, name = nil)
        self.session.create_channel(name, worker_pool_size)
      end

      def configuration
        @configuration ||= Settings.to_url
      end

      def channel
        @channel ||= create_channel
      end
    end

    class Settings < ::Settingslogic
      source Rails.root.join('config', 'amqp.yml')
      namespace Rails.env

      def to_url
        "amqp://#{user}:#{password}@#{host}:#{port}/#{vhost.gsub('/', '%2F')}"
      end

      # Fix rspec integration error
      def to_ary
        to_a
      end
    end
  end
end
