module Logging
  def self.is_enabled_logger
    return false unless defined?(Rails)
    return false unless Rails.logger.present?
    %i[tagged tags named_tags].each do |method|
      return false unless Rails.logger.respond_to?(method)
    end
    true
  end

  def self.boot(app)
    config = app.config

    config.rails_semantic_logger.started = true
    config.rails_semantic_logger.processing = true
    config.rails_semantic_logger.rendered = true

    log_formatter = :json
    # log_formatter = :text

    case log_formatter
    when :json
      config.rails_semantic_logger.format = Logging::JsonFormatter.new
      config.rails_semantic_logger.semantic = true
      config.colorize_logging = false
    when :text
      config.rails_semantic_logger.format = :color
      config.rails_semantic_logger.semantic = false
      config.colorize_logging = true
    else
      raise ArgumentError, "Unknown formatter: #{log_formatter}"
    end

    if ENV["RAILS_LOG_TO_STDOUT"].present?
      Logging::DockerLog.io_list.each do |io|
        io.sync = true
        config.semantic_logger.add_appender(io: io, formatter: config.rails_semantic_logger.format)
      end
      config.rails_semantic_logger.add_file_appender = false
    end

    if ENV["LOG_LEVEL"].present?
      config.log_level = ENV["LOG_LEVEL"].downcase.strip.to_sym
    end

    if config.rails_semantic_logger.semantic
      config.log_tags = { type: 'server', request_id: :request_id }
    else
      config.log_tags = ['server', :request_id]
    end

    app.console do
      SemanticLogger.push_named_tags(type: 'console', id: SecureRandom.uuid)
    end

    app.rake_tasks do
      SemanticLogger.push_named_tags(type: 'rake', id: SecureRandom.uuid)
    end

    app.runner do
      name = Pathname.new(ARGV.first).realpath.relative_path_from(Rails.root.join('script')).sub_ext('') rescue ''
      SemanticLogger.push_named_tags(type: 'runner', id: SecureRandom.uuid, name: name)
      Rails.logger.info(code_or_file: ARGV.join(' '))
    end
  end
end

require_relative '../lib/logging/thread_with_tags'
require_relative '../lib/logging/rake_task_with_tags'
require_relative '../lib/logging/docker_log'
require_relative '../lib/logging/json_formatter'
