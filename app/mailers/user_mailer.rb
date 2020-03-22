# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def registration(user)
    @user = user
    mail(to: @user.email, subject: "Welcome #{user.name}!")
  end

  def deletion(user)
    @user = user
    mail(to: @user.email, subject: "Sorry to see you go #{user.name}!")
  end
end
