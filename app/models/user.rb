# frozen_string_literal: true

class User < ApplicationRecord
  def birthday?
    birth_date == Time.zone.today
  end
end
