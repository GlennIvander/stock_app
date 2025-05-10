class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @url = "http://localhost:3000/users/sign_in"
    mail(to: @user.email, subject: "Your Trader Account Has Been Approved")
  end

  def admin_created_email(user)
    @user = user
    @url = "http://localhost:3000/users/sign_in"
    mail(to: @user.email, subject: "Your Trader Account Has Been Created")
  end
end
