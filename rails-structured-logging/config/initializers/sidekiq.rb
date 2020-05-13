require 'sidekiq/job_logger'

module Logging
  # @see https://github.com/mperham/sidekiq/blob/v6.0.7/lib/sidekiq/job_logger.rb
  class SidekiqJobLogger < Sidekiq::JobLogger
    def call(*_args)
      @logger.push_tags 'Sidekiq' if @logger.formatter.current_tags.blank?
      super
    end
  end
end

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/0" }
  config.options[:job_logger] = Logging::SidekiqJobLogger
end

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/0" }
  config.options[:job_logger] = Logging::SidekiqJobLogger
end
