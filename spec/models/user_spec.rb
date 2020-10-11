# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @current_user = FactoryBot.create(
      :user, login: 'johndoe', email: 'johndoe@doe.com', email_confirmation: 'johndoe@doe.com',
             password: 'changeme', password_confirmation: 'changeme'
    )
  end

  it 'is valid with valid attributes' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'is not valid without login' do
    user = build(:user, login: nil)
    expect(user).to_not be_valid
  end

  it 'is not valid without password digest' do
    user = build(:user, password_digest: nil)
    expect(user).to_not be_valid
  end

  it 'is not valid without an email' do
    user = build(:user, email: nil)
    expect(user).to_not be_valid
  end

  it 'has a unique email' do
    user = build(:user, email: @current_user.email,
                        email_confirmation: @current_user.email)
    expect(user).to_not be_valid
  end

  it 'is not valid without a password' do
    user = build(:user, password: nil)
    expect(user).to_not be_valid
  end
end
