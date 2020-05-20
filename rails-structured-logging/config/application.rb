require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require_relative '../lib/logging'

module RailsStructuredLogging
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Active Job
    config.active_job.queue_adapter = :sidekiq

    # logging
    logger_type = Rails.env.production? ? :structure : :raw

    create_logger = ->(type: :raw, default_tags: []){
      logger = ActiveSupport::Logger.new(STDOUT)
      logger.formatter =  Logger::Formatter.new
      logger = case type
      when :structure then Logging::JsonStructuredTaggedLogging.new(logger)
      when :raw then ActiveSupport::TaggedLogging.new(logger)
      end
      logger = Logging::DefaultTaggedLogging.new(logger, default_tags: default_tags)
      logger
    }

    config.log_tags = [ 'Server', :method, ->(req){ URI.parse(req.fullpath).path }, :request_id ]

    if $is_boot_rails_console
      config.logger = create_logger.call(type: :raw, default_tags: ['Console'])
      config.colorize_logging = true
    else
      config.logger = create_logger.call(type: logger_type)
      config.colorize_logging = logger_type == :raw
    end

    ActiveJob::Base.logger = create_logger.call(type: logger_type)
    Sidekiq.logger = create_logger.call(type: logger_type, default_tags: ['Sidekiq'])
    Logging::TaskLogging.logger_creator = ->{ create_logger.call(type: logger_type) }

    config.lograge.logger = ActiveSupport::Logger.new(STDOUT)
    config.lograge.formatter = Lograge::Formatters::Json.new
  end
end
