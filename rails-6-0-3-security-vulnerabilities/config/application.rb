require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails603SecurityVulnerabilities
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # cache store
    config.cache_store = :redis_store, "redis://#{ENV.fetch('REDIS_HOST')}:#{ENV.fetch('REDIS_PORT')}/0"
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true
    config.active_record.cache_versioning = false
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{3.minutes.to_i}"
    }

    # active storage
    config.active_storage.service = :amazon

    # per_form_csrf_tokens
    Rails.application.config.action_controller.per_form_csrf_tokens = true
  end
end
