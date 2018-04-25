class UsersController < ApplicationController
  include SessionsHelper
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    logger.debug("Debug user create-----")
    logger.debug(@user.image)
    if @user.save
      # 保存の成功した場合の処理
      redirect_to user_path(@user.id)
    else
      render 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
    @favorite_blogs = @user.favorite_blogs
    logger.debug("Debug user show-----")
    logger.debug(@favorite_blogs)
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :image)
  end
end
