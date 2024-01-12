module HasUuid7PrimaryKey
  extend ActiveSupport::Concern

  included do
    raise StandardError, 'primary key type must be UUID' unless columns_hash[primary_key].type == :uuid

    scope :oldest, -> { order(id: :asc) }
    scope :newest, -> { order(id: :desc) }
  end
end
