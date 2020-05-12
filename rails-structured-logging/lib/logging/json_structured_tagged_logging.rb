module Logging
  # Wraps any Logger object to provide tagging and JSON structured capabilities.
  #
  #   logger = Logging::JsonStructuredTaggedLogging.new(Logger.new(STDOUT))
  #   logger.tagged('BCX') { logger.info 'Stuff' }                            # Logs {"severity":"INFO","timestamp":"2020-05-12T07:06:08+00:00","progname":"","message":"Stuff","tags":["BCX"]}
  #   logger.tagged('BCX', "Jason") { logger.info 'Stuff' }                   # Logs {"severity":"INFO","timestamp":"2020-05-12T07:06:22+00:00","progname":"","message":"Stuff","tags":["BCX","Jason"]}
  #   logger.tagged('BCX') { logger.tagged('Jason') { logger.info 'Stuff' } } # Logs {"severity":"INFO","timestamp":"2020-05-12T07:06:30+00:00","progname":"","message":"Stuff","tags":["BCX","Jason"]}
  #
  # @see https://github.com/rails/rails/blob/v6.0.3/activesupport/lib/active_support/tagged_logging.rb
  module JsonStructuredTaggedLogging
    module Formatter
      attr_accessor :structurere

      def default_structurere
        ->(severity, timestamp, progname, message, tags) {
          {
            severity: severity.to_s,
            timestamp: timestamp.iso8601,
            progname: progname.to_s,
            message: message.to_s,
            tags: tags.map(&:to_s),
          }
        }
      end

      def call(severity, timestamp, progname, message)
        result = (structurere || default_structurere).call(severity, timestamp, progname, message, current_tags)
        result = result.to_json + "\n"
        result
      end
    end

    def self.new(logger, structurere: nil)
      logger = if logger.respond_to?(:tagged)
        logger.dup
      else
        ActiveSupport::TaggedLogging.new(logger)
      end

      logger.formatter.extend Formatter
      logger.formatter.structurere = structurere
      logger
    end
  end
end
