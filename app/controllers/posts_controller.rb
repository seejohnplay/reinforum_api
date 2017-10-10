class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :update_vote_score, :destroy]

  def index
    @posts = Post.all
    json_response(@posts)
  end

  def by_category
    category = Category.find_by_name params[:category]
    @posts = Post.where(category: category)
    json_response(@posts)
  end

  def create
    if category_id = params[:category_id]
      category = Category.find category_id 
    end
    @post = Post.create!(post_params.merge(category: category))
    json_response(@post, :created)
  end

  def show
    json_response(@post)
  end

  def update
    @post.update(post_params)
    head :no_content
  end

  def update_vote_score
    vote = params[:option] == 'upvote' ? 1 : params[:option] == 'downvote' ? -1 : 0
    @post.update_attribute(:vote_score, @post.vote_score + vote)
    head :no_content
  end

  def destroy
    @post.destroy
    head :no_content
  end

  private

  def post_params
    params.permit(:author, :category_id, :body, :title)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end