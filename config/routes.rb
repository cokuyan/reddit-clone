Rails.application.routes.draw do
  resources :users, only: [:new, :create, :show, :destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :subs
  resources :posts, except: :index do
    resources :comments, only: :new
  end
  resources :comments, only: [:create, :edit, :update, :destroy]
end
