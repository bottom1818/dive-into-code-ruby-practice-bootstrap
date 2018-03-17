class FavoritesController < ApplicationController
  include SessionsHelper
  
  def create

    favorite = current_user.favorites.create(blog_id: params[:blog_id])
    logger.debug("Debug favorite create-----")
    logger.debug(favorite)
    redirect_to blogs_url, notice: "#{favorite.blog.user.name}さんのブログをお気に入り登録しました"
  end

  def destroy
    favorite = current_user.favorites.find_by(blog_id: params[:blog_id]).destroy
    redirect_to blogs_url, notice: "#{favorite.blog.user.name}さんのブログをお気に入り解除しました"
  end
end
