module Logging
  # @see https://github.com/reidmorrison/semantic_logger/blob/master/lib/semantic_logger/formatters/raw.rb
  # @see https://github.com/reidmorrison/semantic_logger/blob/master/lib/semantic_logger/formatters/json.rb
  class JsonFormatter < SemanticLogger::Formatters::Raw
    def initialize(time_format: :iso_8601, time_key: :timestamp, **args)
      super(time_format: time_format, time_key: time_key, **args)
    end

    def call(log, logger)
      result = super
      result[:type] = result.dig(:named_tags, :type) || 'rails'
      result.to_json
    end
  end
end
