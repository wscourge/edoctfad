# frozen_string_literal: true

class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotUnique, with: :render_duplicated_email_conflict

  def create
    render_invalid(validation_errors) and return if validation_errors.present?
    user = User.new(user_params)
    render_bad_request and return unless user.save!
    render_created(user.attributes)
    UserMailer.registration(user).deliver_now!
  end

  def update
    render_invalid(validation_errors) and return if validation_errors.present?
    render_no_content and return if User.find_by!(resource_identifier).update!(user_params)
    render_bad_request
  end

  def destroy
    user = User.find_by!(resource_identifier).delete
    render_ok(user.attributes)
    UserMailer.deletion(user).deliver_now!
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :birth_date)
  end

  def resource_identifier
    { id: params.require(:id) }
  end

  def validation_errors
    @validation_errors ||= UserContract.new(action_name).call(user_params.to_h).errors
  end

  def render_duplicated_email_conflict
    render_conflict('Email already in use')
  end
end
