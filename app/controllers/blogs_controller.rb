class BlogsController < ApplicationController
  include SessionsHelper
  before_action :set_blog, only: [:show, :edit, :update, :destroy]
  before_action :current_user, only: [:new, :show, :edit, :destroy]
  
  def index
    @blogs = Blog.all
    #binding.pry
    #raise
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
    #Blog.create(title: params[:blog][:title], content: params[:blog][:content])
    #Blog.create(params[:blog])
    #Blog.create(blog_params)
    #redirect_to new_blog_path
    @blog = Blog.new(blog_params)
    @blog.user = current_user
    
    logger.debug("Debug blog create-----")
    logger.debug(@blog)
    logger.debug(@blog.user)
    
    if @blog.save
      # 一覧画面へ遷移して"ブログを作成しました！"とメッセージを表示します。
      redirect_to blogs_path, notice: "ブログを作成しました！"
    else
      # 入力フォームを再描画します。
      render 'new'
    end
    
  end
  
  def show
    #@blog = Blog.find(params[:id])
    if !logged_in?
      redirect_to new_session_path
    end
    @favorite = current_user.favorites.find_by(blog_id: @blog.id)
  end
  
  def edit
    #@blog = Blog.find(params[:id])
    if !logged_in?
      redirect_to new_session_path
    end
  end
  
  def update
    #@blog = Blog.find(params[:id])
    if @blog.update(blog_params)
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