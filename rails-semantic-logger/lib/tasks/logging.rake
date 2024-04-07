namespace :logging do
  desc 'Test logging'
  task test: [:environment, :depend] do
    Rails.logger.tagged('tag1', 'tag2') do
      Rails.logger.info('Before thread')
      t = Thread.new do
        Rails.logger.info('Thread')
        User.first
      end
      Rails.logger.info('After thread')
      t.join()
      Rails.logger.info('Finished thread')
    end
  end

  task :depend do
    Rails.logger.info('depend')
  end
end
