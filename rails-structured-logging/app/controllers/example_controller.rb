class ExampleController < ApplicationController
  def index
    Example.find(5)
    render plain: 'test'
  end
end
