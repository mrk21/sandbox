require_relative '../logging'

namespace :example do
  task :exec => [:environment] do |t|
    t.logger.info 'test'
  end
end
