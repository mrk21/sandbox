namespace :example do
  logging = ->(type, &block) {
    Rails.logger.tagged('Rake', "example:#{type}", SecureRandom.uuid, &block)
  }
  task :exec => [:environment] do
    logging[:exec] do |logger|
      logger.info 'test'
    end
  end
end
