require "rabbithole/version"
require "rabbithole/errors"
require "msgpack"

module Rabbithole
  autoload :Connection, 'rabbithole/connection'
  autoload :Worker, 'rabbithole/worker'
  autoload :ErrorHandler, 'rabbithole/error_handler'
  autoload :CLI, 'rabbithole/cli'
  module ErrorHandlers
    autoload :NullHandler, 'rabbithole/error_handlers/null_handler'
    autoload :RaiseHandler, 'rabbithole/error_handlers/raise_handler'
  end

  class << self
    def enqueue(klass, *args)
      return unless is_queueable?(klass)
      payload = {
        :klass => klass.to_s,
        :args  => args
      }.to_msgpack
      Connection.publish(queue, payload)
    end

    def purge(klass)
      return unless is_queueable?(klass)
      Connection.purge(queue)
    end

    private

    def is_queueable?(klass)
      if klass.is_a?(Class)
        unless klass.respond_to?(:perform)
          raise InvalidJobError.new("The class #{klass} does not define the method perform. I don't know how to execute it...")
        end
      else
        raise UnknownJobError.new("The class #{klass} is not known to Rabbithole. Is it a class?")
      end

      @klass = klass
      true
    end

    def queue
      @klass.instance_variable_defined?(:@queue) ? @klass.instance_variable_get(:@queue) : Connection::DEFAULT_QUEUE
    end
  end
end
