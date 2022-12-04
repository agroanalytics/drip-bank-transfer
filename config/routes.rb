# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/transfer-money', to: 'transfer_money#create'
      get '/wallets', to: 'wallet#show'
    end
  end
end
