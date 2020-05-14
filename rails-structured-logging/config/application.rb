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

require_relative '../lib/logging/json_structured_tagged_logging'

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
    config.log_tags = [ 'Server', :request_id ]

    if $is_boot_rails_console
      config.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
      config.logger.push_tags('Console')
      config.colorize_logging = true
    else
      config.logger = Logging::JsonStructuredTaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
      config.colorize_logging = false
    end

    ActiveJob::Base.logger = Logging::JsonStructuredTaggedLogging.new(ActiveJob::Base.logger)
    Sidekiq.logger = Logging::JsonStructuredTaggedLogging.new(Sidekiq.logger)
    Sidekiq.logger.push_tags('Sidekiq')
  end
end
