module Logging
  module DefaultTaggedLogging
    module Formatter
      attr_accessor :default_tags

      def call(_severity, _timestamp, _progname, _message)
        push_tags() if current_tags.blank?
        super
      end

      def push_tags(*tags)
        tags = default_tags + tags if current_tags.blank?
        super
      end
    end

    def self.new(logger, default_tags: [])
      logger = ActiveSupport::TaggedLogging.new(logger) unless logger.respond_to?(:tagged)
      logger.formatter.extend Formatter
      logger.extend self
      logger.default_tags = default_tags
      logger
    end

    delegate :default_tags, :default_tags=, to: :formatter
  end
end
