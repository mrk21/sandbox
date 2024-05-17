require_relative '../thread_pool'
require_relative '../retryer'
require_relative '../logger_with_indicator'

namespace :mongo do
  desc 'Insert data'
  task insert: :environment  do
    logger = ActiveSupport::Logger.new($stdout)
    logger.formatter = Logger::Formatter.new
    logger.level = Rails.logger.level
    logger.extend ActiveSupport::Logger.broadcast(Rails.logger)
    logger = LoggerWithIndicator.new(logger)

    retryer = Retryer.new(
      Mongo::Error::ConnectionCheckOutTimeout,
      max_attempt: 10,
      backoff: Retryer::ExponentialBackoffAndEqualJitter.new(base: 0.1, cap: 10),
      on_retry: ->(attempt, wait) {
        logger.info "Retrying #{attempt.ordinalize} time(waiting for #{wait.round(3)} seconds)..."
      }
    )
    thread_pool = ThreadPool.new(100)
    user_count = User.count
    article_count = Article.count

    logger.info 'Start'
    thread_pool.start

    10_000_000.times.each_slice(5_000) do |chunk|
      thread_pool.perform do
        users = chunk.map do |i|
          user_no = user_count + i + 1
          {
            name: "user-#{user_no}",
            created_at: Time.zone.now,
            updated_at: Time.zone.now,
          }
        end
        user_results = retryer.retryable do
          User.collection.insert_many(users).tap do
            logger << '.'
          end
        end

        articles = user_results.inserted_ids.each_with_index.map do |id,i|
          5.times.map do |j|
            article_no = article_count + (chunk.first + i) * 5 + j + 1
            {
              user_id: id,
              title: "title-#{article_no}",
              body: "body-#{article_no}",
              created_at: Time.zone.now,
              updated_at: Time.zone.now,
            }
          end
        end
        retryer.retryable do
          Article.collection.insert_many(articles.flatten).tap do
            logger << '*'
          end
        end
      end
    end

    logger.info 'Stopping...'
    thread_pool.stop
    logger.info 'Stopped'
  end
end
