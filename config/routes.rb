Rails.application.routes.draw do
  resources :users, except: %i[destroy show]
  resources :orders, except: %i[show update destroy]
  resources :products, except: %i[destroy show update]
  resources :sessions, only: :create
  # Identifying product for update, by its code, not id.
  patch 'products', to: 'products#update'
  delete 'orders', to: 'orders#destroy'
  root 'https://documenter.getpostman.com/view/13297141/TVYM3FFc'
end
