module WaitForHelpers
  def wait_for(timeout = 1, &block)
    Timeout::timeout(timeout) do
      sleep 0.1 unless block.call
    end
  end
end
