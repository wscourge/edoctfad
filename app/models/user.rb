class User < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :date_of_birth

  def birthday?
    date_of_birth == Date.today
  end

  def send_registration_email
    UserMailer.registration(self).deliver_now
  end
end
