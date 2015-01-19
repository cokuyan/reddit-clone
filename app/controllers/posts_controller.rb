class PostsController < ApplicationController
  before_action :require_author!, only: [:edit, :update, :destroy]
  before_action :require_current_user!, only: [:new, :create]

  def show
    @post = Post.find(params[:id]).decorate
    @comments_by_parent_id = @post.comments_by_parent_id
  end

  def new
    @post = Post.new.decorate
  end

  def create
    @post = Post.new(post_params).decorate
    @post.author_id = current_user.id
    if @post.save
      @post.update_subs!(params[:sub_ids])
      flash[:notice] = "Post added successfully"
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id]).decorate
    @sub_ids = @post.subs.pluck(:id).map(&:to_s)
  end

  def update
    @post = Post.find(params[:id]).decorate
    if @post.update(post_params)
      @post.update_subs!(params[:sub_ids])
      flash[:notice] = "Post updated successfully"
      redirect_to post_url(@post)
    else
      flash.now[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id]).decorate
    @post.destroy
    flash[:notice] = "Post removed successfully"
    redirect_to subs_url
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :content)
  end

  def require_author!
    @post = Post.find(params[:id])
    redirect_to post_url(@post) unless current_user == @post.author
  end
end
