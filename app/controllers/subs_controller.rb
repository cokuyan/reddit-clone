class SubsController < ApplicationController
  before_action :require_moderator!, only: [:edit, :update, :destroy]
  before_action :require_current_user!, only: [:new, :create]

  def index
    @subs = Sub.all
  end

  def show
    @sub = Sub.find(params[:id]).decorate
  end

  def new
    @sub = Sub.new.decorate
  end

  def create
    @sub = Sub.new(sub_params).decorate
    @sub.moderator_id = current_user.id
    if @sub.save
      flash[:notice] = "#{@sub.title} created successfully"
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def edit
    @sub = Sub.find(params[:id]).decorate
  end

  def update
    @sub = Sub.find(params[:id]).decorate
    if @sub.update(sub_params)
      flash[:notice] = "#{@sub.title} updated successfully"
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def destroy
    @sub = Sub.find(params[:id])
    @sub.destroy
    flash[:notice] = "#{@sub.title} removed successfully"
    redirect_to subs_url
  end

  private

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def require_moderator!
    @sub = Sub.find(params[:id])
    redirect_to sub_url(@sub) unless current_user == @sub.moderator
  end
end
