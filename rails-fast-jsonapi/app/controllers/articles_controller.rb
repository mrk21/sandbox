class ArticlesController < ApplicationController
  def index
    articles = Article.all
    options = {
      include: [:author]
    }
    json_string = ArticleSerializer.new(articles, options).serialized_json
    render json: json_string
  end
end
