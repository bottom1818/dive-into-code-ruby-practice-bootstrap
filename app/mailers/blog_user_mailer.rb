class BlogUserMailer < ApplicationMailer
  def blog_user_mail(blog)
    @blog = blog

    mail to: @blog.user.email, subject: "ブログの作業が行われました"
  end
end
