require "shrine"
require "shrine/storage/s3"

s3_options = {
  bucket: "file",
  region: "ap-northeast-1",
  endpoint: ENV.fetch('FILE_AWS_S3_ENDPOINT'),
  access_key_id: ENV.fetch('FILE_ACCESS_KEY_ID'),
  secret_access_key: ENV.fetch('FILE_SECRET_ACCESS_KEY'),
}
Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
  store: Shrine::Storage::S3.new(prefix: "store", **s3_options),
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data
Shrine.plugin :restore_cached_data
