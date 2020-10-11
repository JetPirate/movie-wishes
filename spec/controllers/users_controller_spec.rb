# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  before(:all) do
    @current_user = FactoryBot.create(:user)
    auth_token = AuthenticateUser.call(@current_user.email, @current_user.password).result
    # post '/signin', params: { email: @current_user.email, password: @current_user.password }.to_json
    # puts response.status
    @request_headers = {
      "Content-Type": 'application/json',
      "Authorization": auth_token,
      "HTTPS": 'on'
    }
  end

  describe 'GET users#index' do
    it 'should get index' do
      get '/api/v1/users', headers: @request_headers
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to_not be_empty
    end
  end

  describe 'GET users#show' do
    it 'should get user' do
      get "/api/v1/users/#{@current_user.id}", headers: @request_headers
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to_not be_empty
    end
  end

  describe 'POST users#create' do
    it 'create user with valid attributes' do
      user_params = { user: FactoryBot.attributes_for(:user) }
      post '/api/v1/users', params: user_params.to_json,
                            headers: @request_headers
      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)['auth_token']).to_not be_empty
    end
  end

  describe 'PUT users#update' do
    it 'should update the email' do
      new_email = "new.#{@current_user.email}"
      new_params = { user: {
        email: new_email,
        email_confirmation: new_email
      } }
      put "/api/v1/users/#{@current_user.id}", params: new_params.to_json,
                                               headers: @request_headers
      json = JSON.parse(response.body)
      expect(json['email']).to eq(new_email)
    end

    it 'should update the password' do
      new_password = "new.#{@current_user.password}"
      new_params = { user: {
        password: new_password,
        password_confirmation: new_password
      } }
      put "/api/v1/users/#{@current_user.id}", params: new_params.to_json,
                                               headers: @request_headers
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE users#destroy' do
    it 'should delete user' do
      delete "/api/v1/users/#{@current_user.id}", headers: @request_headers
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to_not be_empty
    end
  end
end
