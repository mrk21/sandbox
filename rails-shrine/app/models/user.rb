class User < ApplicationRecord
  include AvatarUploader::Attachment(:avatar)

  validates :name, presence: true
end
