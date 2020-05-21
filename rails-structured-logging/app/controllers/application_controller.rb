class ApplicationController < ActionController::Base
  before_action :set_request_time
  rescue_from StandardError, with: :handle_error_500
  rescue_from ActiveRecord::RecordNotFound, with: :handle_error_404

  private

  def handle_error_404(e)
    log_exception(e, level: 'WARN')
    render plain: 'error 404'
  end

  def handle_error_500(e)
    log_exception(e)
    render plain: 'error 500'
  end

  def set_request_time
    @request_time = Time.zone.now
  end

  def append_info_to_payload(payload)
    super
    payload[:time] = @request_time
    payload[:ip] = request.remote_ip
    payload[:referer] = request.referer
    payload[:user_agent] = request.user_agent
    payload[:request_id] = request.request_id
    payload[:level] = @lograge_level if @lograge_level.present?

    if @lograge_exception.present?
      e = @lograge_exception
      payload[:exception_object] ||= e
      payload[:exception] ||= [e.class.name, e.message]
    end
  end

  # action --[exception]--> rescue_from (call set_lograge_exception) --> append_info_to_payload
  # @see https://tech.actindi.net/2017/08/28/rails-cloudwatchlogs.html
  def log_exception(e, level: 'ERROR')
    level = level.to_s.upcase
    message = case level
    when 'WARN'
      e.inspect
    else
      [e.inspect, *e.backtrace].join("\n")
    end
    Rails.logger.send(level.downcase, message)
    @lograge_exception = e
    @lograge_level = level
  end
end
