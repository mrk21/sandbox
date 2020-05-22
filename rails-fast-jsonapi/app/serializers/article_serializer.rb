class ArticleSerializer
  include FastJsonapi::ObjectSerializer
  belongs_to :author
  attributes :title, :body
end
