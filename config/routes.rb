Rails.application.routes.draw do
  resources :users, except: :destroy
  resources :orders
  resources :products, except: :destroy
  resources :sessions, only: %i[create destroy]
end
