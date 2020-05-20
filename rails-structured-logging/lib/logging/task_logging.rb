require_relative './default_tagged_logging'

module Logging
  module TaskLogging
    cattr_accessor :logger_creator, default: ->{ ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

    def task_id
      @task_id ||= SecureRandom.uuid
    end

    def logger
      @logger ||= Logging::DefaultTaggedLogging.new(
        Logging::TaskLogging.logger_creator.call,
        default_tags: ['Rake', name, task_id]
      )
    end
  end
end

module Rake
  class Task
    include Logging::TaskLogging
  end
end
