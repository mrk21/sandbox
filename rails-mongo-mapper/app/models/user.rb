class User
  include MongoMapper::Document

  key :name, String
  timestamps!

  many :articles

  ensure_index :name
  ensure_index :created_at
end
