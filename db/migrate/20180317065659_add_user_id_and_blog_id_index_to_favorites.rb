class AddUserIdAndBlogIdIndexToFavorites < ActiveRecord::Migration[5.1]
  def change
    add_index :favorites, [:user_id, :blog_id], :unique => true
  end
end
