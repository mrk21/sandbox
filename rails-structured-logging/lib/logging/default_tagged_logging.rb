module Logging
  module DefaultTaggedLogging
    module Formatter
      attr_accessor :default_tags

      def call(_severity, _timestamp, _progname, _message)
        push_tags([]) if current_tags.blank?
        super
      end

      def push_tags(*tags)
        tags = default_tags + tags if current_tags.blank?
        super
      end
    end

    def self.new(logger, default_tags: [])
      if logger.respond_to?(:default_tags)
        logger = logger.dup
      else
        logger = if logger.respond_to?(:tagged)
          logger.dup
        else
          ActiveSupport::TaggedLogging.new(logger)
        end

        logger.formatter.extend Formatter
        logger.extend self
      end

      logger.default_tags = default_tags
      logger
    end

    delegate :default_tags, :default_tags=, to: :formatter
  end
end
