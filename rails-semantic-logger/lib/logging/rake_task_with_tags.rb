# @see [Railsアプリでrakeタスクのログを見やすくする - アジャイルSEの憂鬱](https://sinsoku.hatenablog.com/entry/2019/02/15/192151)
module Logging
  module RakeTaskWithTags
    def execute(args)
      return super unless Logging.is_enabled_logger
      Rails.logger.tagged(task: name) do
        Rails.logger.info('args', args: args)
        super
      end
    end
  end
end

if defined?(Rake)
  Rake::Task.prepend(Logging::RakeTaskWithTags)
end
