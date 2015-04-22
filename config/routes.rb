Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get 'login', :to => 'devise/sessions#new'
    delete 'logout', :to => 'devise/sessions#destroy'
    get 'register', :to => 'registrations#new'
    get 'settings', :to => 'devise/registrations#edit'
  end
  resource :guest_user, only: [:edit, :update, :create]
  devise_for :admins

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  authenticated :user do
    root 'pages#dashboard', as: :user_root
  end
  root 'pages#index'
  get 'help' => 'pages#help', as: 'help'

  get 'my_battles' => 'pages#my_battles', as: 'my_battles'
  resources :battles
  get 'leaderboard' => 'pages#leaderboard', as: 'leaderboard'

  resources :units_for_hire, controller: "unit_templates", as: "unit_templates" do
    member do
      post :hire
      post :hire_equipped
    end
  end
  resources :units do
    collection do
      post :unassign
    end
    member do
      post :extract
    end
  end
  resources :equipment do
    member do
      post :buy
    end
  end
  resources :user_equipment
  resources :arenas

  resources :quests
  resources :raids do
    member do
      get :rerun, to: "raids#get_rerun"
      post :rerun
    end
  end

  resource :my_profile do
    member do
      post :skip_tutorial
      put :begin_speedrun
    end
  end
end
