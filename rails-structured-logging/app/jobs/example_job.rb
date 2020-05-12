class ExampleJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.info "### test"
  end
end
