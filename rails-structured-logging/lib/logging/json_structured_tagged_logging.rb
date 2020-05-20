require_relative './entity'

module Logging
  # Wraps any Logger object to provide tagging and JSON structured capabilities.
  #
  #   logger = Logging::JsonStructuredTaggedLogging.new(Logger.new(STDOUT))
  #   logger.tagged('BCX') { logger.info 'Stuff' }                            # Logs {"type":"rails","time":"2020-05-14T06:38:25Z","level":"INFO","sub_type":"other","request_id":null,"job_name":null,"job_id":null,"message":"Stuff","tags":["BCX"]}
  #   logger.tagged('BCX', "Jason") { logger.info 'Stuff' }                   # Logs {"type":"rails","time":"2020-05-14T06:38:42Z","level":"INFO","sub_type":"other","request_id":null,"job_name":null,"job_id":null,"message":"Stuff","tags":["BCX","Jason"]}
  #   logger.tagged('BCX') { logger.tagged('Jason') { logger.info 'Stuff' } } # Logs {"type":"rails","time":"2020-05-14T06:38:51Z","level":"INFO","sub_type":"other","request_id":null,"job_name":null,"job_id":null,"message":"Stuff","tags":["BCX","Jason"]}
  #
  # @see https://github.com/rails/rails/blob/v6.0.3/activesupport/lib/active_support/tagged_logging.rb
  module JsonStructuredTaggedLogging
    module Formatter
      def call(severity, timestamp, _progname, message)
        result = Logging::Entity::RailsLog.new(
          time: timestamp,
          level: severity,
          message: message,
          tags: current_tags
        )
        result = result.to_json + "\n"
        result
      end
    end

    def self.new(logger)
      logger = ActiveSupport::TaggedLogging.new(logger) unless logger.respond_to?(:tagged)
      logger.formatter.extend Formatter
      logger.extend self
      logger
    end
  end
end
