module Rabbithole
  module ErrorHandlers
    class RaiseHandler
      def self.handle(error)
        raise error
      end
    end
  end
end
