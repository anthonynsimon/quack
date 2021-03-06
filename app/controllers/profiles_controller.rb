class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_edit, only: [:edit, :update, :destroy]

  def show
    if @user.nil?
      not_found
      return
    end

    @posts = @user.posts.order(:created_at).reverse_order
  end

  def edit
  end

  def update
    if @user.update(profile_params)
      flash[:success] = 'Profile updated!'
      redirect_to profile_path(@user.user_name)
    else
      flash.now[:error] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by(user_name: params[:user_name])
  end

  def profile_params
    params.require(:user).permit(:user_name, :bio, :avatar)
  end

  def authorize_edit
    redirect_to root_path if current_user != @user
  end
end
