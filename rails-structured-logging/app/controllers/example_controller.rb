class ExampleController < ApplicationController
  def ok
    render plain: 'ok'
  end

  def error_404
    Example.find(5)
    render plain: 'ng'
  end

  def error_500
    raise StandardError, '500 error'
    render plain: 'ng'
  end
end
