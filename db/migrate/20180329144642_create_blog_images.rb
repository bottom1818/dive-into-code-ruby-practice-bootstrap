class CreateBlogImages < ActiveRecord::Migration[5.1]
  def change
    create_table :blog_images do |t|
      t.text :image
      t.references :blog, foreign_key: true

      t.timestamps
    end
  end
end
