require 'mock_redis' if Rails.env.test?

CoreRedisConfig = {
    host: ENV['REDIS_HOST'] || 'localhost',
    port: 6379,
    db: 6,
    id: nil
}

$redis = Rails.env.test? ? MockRedis.new : Redis.new(CoreRedisConfig)
