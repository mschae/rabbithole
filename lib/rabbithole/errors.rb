module Rabbithole
  class RabbitholeError < StandardError; end

  class UnknownJobError < StandardError; end
  class InvalidJobError < StandardError; end
end
