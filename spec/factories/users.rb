# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { FFaker::Name.first_name }
    email { FFaker::Internet.email }
    birth_date { 20.years.ago.to_date }
  end
end
