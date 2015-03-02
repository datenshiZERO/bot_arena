Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'login', :to => 'devise/sessions#new'
    delete 'logout', :to => 'devise/sessions#destroy'
    get 'register', :to => 'registrations#new'
    get 'settings', :to => 'devise/registrations#edit'
  end
  devise_for :admins

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  authenticated :user do
    root 'pages#dashboard', as: :user_root
  end
  root 'pages#index'

  get 'my_battles' => 'pages#my_battles', as: 'my_battles'
  resources :battles

  resources :unit_templates do
    member do
      post :hire
      post :hire_equipped
    end
  end
  resources :units
  resources :equipment do
    member do
      post :buy
    end
  end
  resources :user_equipment
  resources :arenas
end
