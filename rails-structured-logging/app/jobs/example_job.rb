class ExampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts '### hoge'
    logger.info "### test"
  end
end
