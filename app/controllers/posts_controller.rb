class PostsController < ApplicationController
  def index
    @posts = Post.all
    json_response(@posts)
  end

  def by_category
    category = Category.find_by_name params[:category]
    @posts = Post.where(category: category)
    json_response(@posts)
  end

  private

  def post_params
    params.permit(:author, :body)
  end
end
