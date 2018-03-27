class BlogsController < ApplicationController
  include SessionsHelper
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :current_user, only: [:new, :show, :edit, :destroy]
  
  def index
    @blogs = Blog.all
  end

  def new
    if !logged_in?
      redirect_to new_session_path
    end
    if params[:back]
      @blog = Blog.new(blog_params)
    else
      @blog = Blog.new
    end
    @blog.user = current_user

  logger.debug("Debug blog new-----")
  logger.debug(@blog)
  logger.debug(@blog.user)

  end
  
  def create
    @blog = Blog.new(blog_params)
    @blog.user = current_user
    
    logger.debug("Debug blog create-----")
    logger.debug(@blog)
    logger.debug(@blog.user)
    
    if @blog.save
      # 作成したことをメールで通知します
      BlogUserMailer.blog_user_mail(@blog).deliver
      
      # 一覧画面へ遷移して"ブログを作成しました！"とメッセージを表示します。
      redirect_to blogs_path, notice: "ブログを作成しました！"
    else
      # 入力フォームを再描画します。
      render 'new'
    end
    
  end
  
  def show
    if !logged_in?
      redirect_to new_session_path
    end
    @favorite = current_user.favorites.find_by(blog_id: @blog.id)
  end
  
  def edit
    if !logged_in?
      redirect_to new_session_path
    end
  end
  
  def update
    if @blog.update(blog_params)
      # 編集したことをメールで通知します
      BlogUserMailer.blog_user_mail(@blog).deliver
      redirect_to blogs_path, notice: "ブログを編集しました！"
    else
      render 'edit'
    end
  end
  
  def destroy
    if !logged_in?
      redirect_to new_session_path
    end
    @blog.destroy
    # 削除したことをメールで通知します
    BlogUserMailer.blog_user_mail(@blog).deliver
    redirect_to blogs_path, notice:"ブログを削除しました！"
  end
  
  def confirm
    @blog = Blog.new(blog_params)
    @blog.user = current_user

    logger.debug("Debug blog confirm-----")
    logger.debug(@blog)
    logger.debug(@blog.user)
    render :new if @blog.invalid?
  end
  
  private
  def blog_params
    params.require(:blog).permit(:title, :content)
  end
  
  private
  def set_blog
    @blog = Blog.find(params[:id])
  end
  
end