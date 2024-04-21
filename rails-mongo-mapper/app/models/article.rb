class Article
  include MongoMapper::Document

  key :title, String
  key :body, String
  timestamps!

  belongs_to :user

  ensure_index :user_id
  ensure_index :title
  ensure_index :created_at
end
