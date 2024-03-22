require "image_processing/vips"
require 'my_validation_helpers'

class AvatarUploader < Shrine
  plugin :validation
  plugin :my_validation_helpers
  plugin :determine_mime_type
  plugin :derivatives
  plugin :store_dimensions, analyzer: :ruby_vips
  plugin :backgrounding

  Attacher.validate do
    validate_mime_type %w[image/jpeg image/png]
  end

  Attacher.derivatives do |original|
    vips = ImageProcessing::Vips.source(original)
    {
      large: vips.resize_to_limit!(800, 800),
      medium: vips.resize_to_limit!(500, 500),
      small: vips.resize_to_limit!(300, 300),
    }
  end

  Attacher.promote_block do
    PromoteJob.perform_later(self.class.name, record.class.name, record.id, name.to_s, file_data)
  end

  Attacher.destroy_block do
    DestroyJob.perform_later(self.class.name, data)
  end

  class PromoteJob < ApplicationJob
    def perform(attacher_class, record_class, record_id, name, file_data)
      attacher_class = Object.const_get(attacher_class)
      record = Object.const_get(record_class).find(record_id)

      attacher = attacher_class.retrieve(model: record, name: name, file: file_data)
      attacher.create_derivatives
      attacher.atomic_promote
    rescue Shrine::AttachmentChanged, ActiveRecord::RecordNotFound => e
      Rails.logger.warn e
    end
  end

  class DestroyJob < ApplicationJob
    def perform(attacher_class, data)
      attacher_class = Object.const_get(attacher_class)

      attacher = attacher_class.from_data(data)
      attacher.destroy
    end
  end
end
