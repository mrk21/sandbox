module UseUuidV4PrimaryKey
  extend ActiveSupport::Concern

  included do
    indexes = ActiveRecord::Base.connection.indexes(table_name)

    raise StandardError, 'primary key type must be UUID' unless columns_hash[primary_key].type == :uuid
    raise StandardError, '`created_at` is required' if columns_hash['created_at'].blank?
    Rails.logger.warn('`created_at` should set B-tree index') if indexes.find{|idx| idx.columns == ['created_at'] && idx.using == :btree}.blank?

    self.implicit_order_column = :created_at
    scope :oldest, -> { order(created_at: :asc) }
    scope :latest, -> { order(created_at: :desc) }
  end
end
