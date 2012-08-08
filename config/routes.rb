Silo::Application.routes.draw do
  root to: 'experts#index'

  # Login
  get    'login' => 'login#welcome'
  post   'login' => 'login#login'
  delete 'login' => 'login#logout'

  # Users
  get 'profile' => 'users#profile'
  put 'profile' => 'users#update_profile'

  resources :users, except: [:show]

  # Experts
  get 'experts(/page/:page)' => 'experts#index', as: :experts

  resources :experts, except: [:index] do
    resources :cvs, only: [:show, :create, :destroy]

    member do
      get :documents
    end
  end

  # Partners
  resources :partners

  # References
  resources :references
end
