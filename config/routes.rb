require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do

  resources :accounts do
    collection do
      get 'transactions'
      get 'all_spends_chart'
    end
  end

  resources :transactions do
  end
  
  resources :spends do
  end

  resources :matchers do
  end


  resources :imports, only: [:index, :show, :create] do
    member do
      get 'status'
    end
  end

  mount Sidekiq::Web => '/admin/sidekiq', :constraints => AdminConstraint.new
  mount PgHero::Engine, at: "/admin/pghero", :constraints => AdminConstraint.new

  get 'signup', to: 'signup#new', as: 'signup'
  post 'signup', to: 'signup#create'

  resources :sessions, only: [:create]
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  root 'accounts#index'
end
