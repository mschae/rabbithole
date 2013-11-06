module Rabbithole
  class ErrorHandler
    class << self
      @@registered_handler = Rabbithole::ErrorHandlers::RaiseHandler

      def handle(error)
        @@registered_handler.handle(error)
      end

      def register_handler(handler)
        @@registered_handler = handler
      end
    end
  end
end


