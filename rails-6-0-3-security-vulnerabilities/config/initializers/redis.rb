require 'redis'

Redis.current = Redis.new(
  host: ENV.fetch('REDIS_HOST'),
  port: ENV.fetch('REDIS_PORT'),
  db: 0
)