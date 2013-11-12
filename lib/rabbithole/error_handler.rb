module Rabbithole
  class ErrorHandler
    class << self
      @@registered_handler = Rabbithole::ErrorHandlers::RaiseHandler

      def handle(error, queue, payload)
        @@registered_handler.handle(error, queue, payload)
      end

      def register_handler(handler)
        @@registered_handler = handler
      end
    end
  end
end


