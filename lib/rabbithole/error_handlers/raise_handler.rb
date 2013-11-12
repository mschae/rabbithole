module Rabbithole
  module ErrorHandlers
    class RaiseHandler
      def self.handle(error, queue, payload)
        raise error
      end
    end
  end
end
