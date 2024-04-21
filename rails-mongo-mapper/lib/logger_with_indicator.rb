# @see [Print to log file without newline - Ruby on Rails - Stack Overflow](https://stackoverflow.com/questions/22313168/print-to-log-file-without-newline-ruby-on-rails)
class LoggerWithIndicator
  def initialize(logger)
    @base = logger
    @mutex = Mutex.new
    @need_newline = false
  end

  %i[debug info warn error fatal unknown].each do |method|
    define_method(method) do |message|
      output { @base.send(method, message) }
    end
  end

  %i[add log].each do |method|
    define_method(method) do |severity, message = nil, progname = nil, &block|
      output { @base.send(method, severity, message, progname, &block) }
    end
  end

  def <<(msg)
    @mutex.synchronize do
      @need_newline = msg.last != "\n"
      @base << msg
    end
  end

  def method_missing(method, *args, &block)
    @base.send(method, *args, &block)
  end

  private

  def output
    @mutex.synchronize do
      if @need_newline
        @base << "\n"
        @need_newline = false
      end
      yield
    end
  end
end
