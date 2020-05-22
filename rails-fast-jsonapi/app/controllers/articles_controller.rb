class ArticlesController < ApplicationController
  def show
    article = Article.find(params[:id])
    options = {
      include: [:author]
    }
    json_string = ArticleSerializer.new(article, options).serialized_json
    render json: json_string
  end

  def index
    articles = Article.page(params[:page]).per(params[:per])
    options = {
      meta: {
        pagination: make_pagination_info(articles)
      },
      include: [:author]
    }
    json_string = ArticleSerializer.new(articles, options).serialized_json
    render json: json_string
  end

  private

  def make_pagination_info(records)
    {
      total_count: records.total_count,
      per_page: records.limit_value,
      current_page: records.current_page,
      current_page: 1,
      next_page: records.next_page,
      prev_page: records.prev_page,
    }
  end
end
