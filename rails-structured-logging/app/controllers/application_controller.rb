class ApplicationController < ActionController::Base
  after_action :hoge
  rescue_from ActiveRecord::RecordNotFound, with: :error_404

  protected

  def error_404(e)
    set_lograge_exception(e)
    render plain: '404'
  end

  def append_info_to_payload(payload)
    super
    payload[:ip] = request.remote_ip
    payload[:referer] = request.referer
    payload[:user_agent] = request.user_agent
    payload[:request_id] = request.request_id
    payload[:level] = @lograge_level if @lograge_level.present?

    if @lograge_exception.present?
      e = @lograge_exception
      payload[:exception_object] ||= e
      payload[:exception] ||= [e.class, e.message]
    end
  end

  # @see https://tech.actindi.net/2017/08/28/rails-cloudwatchlogs.html
  def set_lograge_exception(e, level: 'ERROR')
    @lograge_exception = e
    set_lograge_level(level)
  end

  def set_lograge_level(level)
    @lograge_level = level
  end
end
