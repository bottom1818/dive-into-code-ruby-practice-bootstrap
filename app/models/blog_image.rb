class BlogImage < ApplicationRecord
  belongs_to :blog
  
  mount_uploader :image, ImageUploader
  
end
