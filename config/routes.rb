# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'messages#index'

  get '/message/new/:reply', to: 'messages#new', as: :new_message
  post '/message/new/:reply', to: 'messages#create', as: :create_message

  resources :messages

  post '/payments/new/:user_id', to: 'payments#create', as: :new_payment
end
