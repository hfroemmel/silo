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
    resources :cvs,         only: [:show, :create, :destroy]
    resources :attachments, only: [:show, :create, :destroy]
    resources :contacts,    only: [:create, :destroy]
    resources :addresses,   only: [:create, :destroy]

    get :documents, on: :member
  end

  # Partners
  get 'partners(/page/:page)' => 'partners#index', as: :partners

  resources :partners, except: [:index] do
    resources :attachments, only: [:show, :create, :destroy]
    resources :employees,   only: [:index, :create, :update, :destroy]

    get :documents, on: :member
  end

  resources :employees, only: [] do
    resources :contacts, only: [:create, :destroy]
  end

  # References
  resources :references

  # Lists
  get 'lists(/page/:page)' => 'lists#index', as: :lists

  resources :lists, only: [:create, :update, :destroy] do
    get :current, on: :collection
    put :copy,    on: :member

    [:experts, :partners].each do |resource|
      resources resource, only: [], controller: :lists do
        get    :index,   action: resource,              on: :collection
        delete :destroy, action: :"remove_#{resource}", on: :member
      end
    end
  end

  # Ajax
  namespace :ajax do
    resources :help,    only: :show
    resources :helpers, only: :show
    resources :tags,    only: :show

    resources :experts, only: [] do
      resources :addresses,   only: :new
      resources :contacts,    only: :new
      resources :attachments, only: :new
      resources :cvs,         only: :new
    end

    resources :partners, only: [] do
      resources :attachments, only: :new
      resources :employees,   only: [:new, :edit]
    end

    resources :employees, only: [] do
      resources :contacts, only: :new
    end

    [:areas, :languages].each do |controller|
      resources controller, only: :index
    end

    resources :lists, except: [:update, :destroy] do
      put :open, on: :member
      get :copy, on: :member

      [:experts, :partners].each do |resource|
        resources resource, only: [], controller: :lists do
          put    :update,  action: :"add_#{resource}",    on: :member
          delete :destroy, action: :"remove_#{resource}", on: :member
        end
      end
    end
  end
end
