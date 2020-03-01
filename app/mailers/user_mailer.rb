class UserMailer < ApplicationMailer  
  
  def registration(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome ' + @user.name + '!')
  end
end
