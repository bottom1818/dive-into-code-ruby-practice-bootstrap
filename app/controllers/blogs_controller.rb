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
      
      if !params[:cache].nil? && params[:cache][:image].present?
        # Feedテーブルの中に、imageのカラム（画像アップロード用のカラム）以外のものがある場合、
        # Feed.newではなくFeed.new(feed_params)にする。
        @blog_image = BlogImage.new(blog_image_params)
        # 画像保存（create）の際に、キャッシュから画像を復元してnewに入れる
        # newに戻る際も、createと同様に復元処理が必要となる。
        @blog_image.image.retrieve_from_cache! params[:cache][:image]
      end
      
    else
      @blog = Blog.new
      @blog_image = BlogImage.new()
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
    
    #if !params[:cache].nil?
    if !params[:cache].nil? && params[:cache][:image].present?
      logger.debug("Debug blog_image create-----")
      # Feedテーブルの中に、imageのカラム（画像アップロード用のカラム）以外のものがある場合、
      # Feed.newではなくFeed.new(feed_params)にする。
      @blog_image = BlogImage.new(blog_image_params)
      # 画像保存（create）の際に、キャッシュから画像を復元してnewに入れる
      # newに戻る際も、createと同様に復元処理が必要となる。
      @blog_image.image.retrieve_from_cache! params[:cache][:image]
    end
    
    logger.debug("Debug blog_image create-----")
    logger.debug(@blog_image)
    
    if @blog.save
      if !params[:cache].nil? && params[:cache][:image].present?
        @blog_image.blog_id = @blog.id
        @blog_image.save
      end
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
    @blog_image = @blog.blog_images.find_by(blog_id: @blog.id)
  end
  
  def edit
    if !logged_in?
      redirect_to new_session_path
    end
    @blog_image = @blog.blog_images.find_by(blog_id: @blog.id)
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
    
    #@blog_image = BlogImage.new(image: params[:blog][:image])
    @blog_image = BlogImage.new(blog_image_params)
    
    logger.debug("Debug blog_image confirm-----")
    logger.debug(@blog_image)

    render :new if @blog.invalid?
  end
  
  private
  def blog_params
    params.require(:blog).permit(:title, :content )
  end
  
  def blog_image_params
    params.require(:blog).permit(:image, :image_cache)
  end

  
  private
  def set_blog
    @blog = Blog.find(params[:id])
  end
  
end