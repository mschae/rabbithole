require "rabbithole/version"
require "rabbithole/errors"
require "msgpack"

module Rabbithole
  autoload :Connection, 'rabbithole/connection'
  autoload :Worker, 'rabbithole/worker'
  module ErrorHandlers
    autoload :NullHandler, 'rabbithole/error_handlers/null_handler'
    autoload :RaiseHandler, 'rabbithole/error_handlers/raise_handler'
  end

  def self.enqueue(klass, *args)
    if klass.is_a?(Class)
      if klass.respond_to?(:perform)
        payload = {
          :klass => klass.to_s,
          :args  => args
        }.to_msgpack

        queue = klass.instance_variable_defined?(:@queue) ? klass.instance_variable_get(:@queue) : Connection::DEFAULT_QUEUE
        Connection.publish(queue, payload)
      else
        raise InvalidJobError.new("The class #{klass} does not define the method perform. I don't know how to execute it...")
      end
    else
      raise UnknownJobError.new("The class #{klass} is not known to Rabbithole. Is it a class?")
    end
  end
end
