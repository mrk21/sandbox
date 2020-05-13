Rails.application.configure do
  config.lograge.enabled = true
  config.lograge.keep_original_rails_log = true

  config.lograge.logger = config.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
  config.lograge.formatter = Lograge::Formatters::Json.new

  config.lograge.custom_options = lambda do |event|
    exceptions = %w(controller action format authenticity_token)
    data = OpenStruct.new(
      timestamp: event.time,
      level: event.payload[:level] || 'INFO',
      request_id: event.payload[:request_id],
      ip: event.payload[:ip],
      referer: event.payload[:referer],
      user_agent: event.payload[:user_agent],
      params: event.payload[:params].except(*exceptions)
    )
    if event.payload[:exception].present?
      data.level = event.payload[:level] || 'FATAL'
      data.exception = event.payload[:exception]
      data.exception_backtrace = event.payload[:exception_object]&.backtrace
    end
    data.to_h
  end
end