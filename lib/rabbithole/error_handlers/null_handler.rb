module Rabbithole
  module ErrorHandlers
    class NullHandler
      def self.handle(error, queue, payload)
        # do nothing
      end
    end
  end
end
