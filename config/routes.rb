# frozen_string_literal: true

Rails.application.routes.draw do
  post 'signin', to: 'authentication#authenticate'

  namespace :api do
    namespace :v1 do
      resources :users, except: %i[new edit] # do
        # gives id param
        # member do
        # end
      # end
    end
  end
end
