class Retryer
  class RetryError < StandardError; end

  class Backoff
    def call(attempt)
      raise NotImplementedError
    end
  end

  class ExponentialBackoff < Backoff
    def initialize(base:, cap:)
      @base = base
      @cap = cap
    end

    def call(attempt)
      [@cap, 2 ** attempt * @base].min
    end
  end

  class ExponentialBackoffAndEqualJitter < ExponentialBackoff
    def call(attempt)
      exp = super
      exp / 2.0 + random_between(0, exp / 2.0)
    end

    private

    def random_between(min, max)
      rand * (max - min) + min
    end
  end

  def initialize(
    *retryable_exceptions,
    max_attempt: 10,
    backoff: ExponentialBackoffAndEqualJitter.new(base: 0.1, cap: 10),
    on_retry: ->(attempt, wait) {}
  )
    @retryable_exceptions = retryable_exceptions.empty? ? [RetryError] : retryable_exceptions
    @max_attempt = max_attempt
    @backoff = backoff
    @on_retry = on_retry
  end

  def retryable(&block)
    attempt = 0
    begin
      return block.call
    rescue *@retryable_exceptions
      raise if attempt >= @max_attempt
      attempt += 1
      wait = @backoff.call(attempt)
      @on_retry.call(attempt, wait)
      sleep wait
      retry
    end
  end
end
