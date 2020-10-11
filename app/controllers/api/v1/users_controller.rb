# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request, only: :create
      before_action :find_user, only: %i[show]

      def index
        users = User.all
        json_response(users)
      end

      def show
        json_response(@user)
      end

      def create
        user = User.create!(user_params)
        auth_token = AuthenticateUser.new(user.email, user.password).call
        response = { user: user, auth_token: auth_token }
        json_response(response, :created)
      end

      def update
        current_user.update!(user_params)
        json_response(current_user, :ok)
      end

      def destroy
        current_user.destroy
        json_response(current_user, :ok)
      end

      private

      def user_params
        params.require(:user).permit(
          :login,
          :email,
          :email_confirmation,
          :password,
          :password_confirmation
        )
      end

      def find_user
        @user = User.find(params[:id])
      end
    end
  end
end
