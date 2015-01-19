class CommentsController < ApplicationController
  before_action :require_author!, only: [:edit, :update, :destroy]
  before_action :require_current_user!, only: [:new, :create]

  def new
    @comment = Comment.new(
      post_id: params[:post_id],
      parent_comment_id: params[:parent_comment_id].to_i
    ).decorate
  end

  def create
    @comment = Comment.new(comment_params).decorate
    @comment.author_id = current_user.id
    if @comment.save
      flash[:notice] = "Comment added successfully"
      redirect_to post_url(@comment.post)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :new
    end
  end

  def edit
    @comment = Comment.find(params[:id]).decorate
  end

  def update
    @comment = Comment.find(params[:id]).decorate
    if @comment.update(comment_params)
      flash[:notice] = "Comment updated successfully"
      redirect_to post_url(@comment.post)
    else
      flash.now[:errors] = @comment.errors.full_messages
      render :edit
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Comment removed successfully"
    redirect_to post_url(@comment.post)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id, :parent_comment_id)
  end

  def require_author!
    @comment = Comment.find(params[:id])
    redirect_to comment_url(@comment) unless current_user == @comment.author
  end
end
