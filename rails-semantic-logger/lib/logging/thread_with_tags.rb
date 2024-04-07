module Logging
  module ThreadWithTags
    def initialize(*args, &block)
      return super unless Logging.is_enabled_logger
      named_tags = Rails.logger.named_tags
      tags = Rails.logger.tags
      super(named_tags, tags, *args) do |named_tags, tags, *args|
        Rails.logger.tagged(named_tags) do
          Rails.logger.tagged(*tags) do
            block.call(*args)
          end
        end
      end
    end
  end
end

Thread.prepend(Logging::ThreadWithTags)
