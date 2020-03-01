class UsersController < ApplicationController

  def create
    User.create(params[:user]).send_registration_email
  end

  def update
    User.find(params[:id]).update(params[:user])
  end

  def delete
    User.delete(params[:id])
  end
end
