class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :update_vote_score, :update, :destroy]

  def show
    json_response(@comment)
  end

  def create
    if post_id = params[:post_id]
      post = Post.find post_id
    end
    @comment = Comment.create!(comment_params.merge(post: post))
    json_response(@comment, :created)
  end

   def update
    @comment.update(comment_params)
    json_response(@comment)
  end

   def update_vote_score
    vote = params[:option] == 'upvote' ? 1 : params[:option] == 'downvote' ? -1 : 0
    @comment.update_attribute(:vote_score, @comment.vote_score + vote)
    json_response(@comment)
  end

  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def comment_params
    params.permit(:author, :body, :post_id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
