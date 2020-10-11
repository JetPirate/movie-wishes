# frozen_string_literal: true

FactoryBot.define do
  sequence :login do |n|
    "#{n}-#{Faker::Internet.username}"
  end

  factory :user do
    login
    email { Faker::Internet.email }
    email_confirmation { email }
    password { Faker::Internet.password }
    password_confirmation { password }
  end
end
