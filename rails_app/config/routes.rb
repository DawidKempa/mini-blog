Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  authenticated :user do
    root "posts#index", as: :authenticated_root
  end

  unauthenticated :user do
    root to: redirect("/users/sign_in"), as: :unauthenticated_root
  end

  resources :posts, only: [:index, :show] do
    resources :comments, only: [:create, :destroy, :edit, :update]
    collection { get 'aktualnosci' }
  end

  resources :contact_form, only: %i[index new create]

  namespace :admin do
    root to: "posts#index"
    resources :posts do
      resources :comments, only: [:create]
      member do
        post :generate_pdf
      end
    end

    resources :comments, only: [:index, :edit, :update, :destroy]

    resources :users

    resources :pages, except: [:show] do
      post 'attachments', on: :member
    end

    get 'export_pdf', to: 'pdf#export', as: :export_pdf
    get 'pdf/download', to: 'pdf#download', as: 'download_pdf'

    get 'pages/*path', to: 'pages#show', as: :page_show,
        format: false, constraints: { path: /.*/ }


  end

  resources :pages, only: [:index]

  get 'pages/*path', to: 'pages#show', as: :page, format: false

  namespace :api, defaults: { format: :json } do
    resources :posts, only: [:index, :show]
    post "contact", to: "contact#create"
    resources :pages, only: [:index, :show]
    resources :comments, only: [:index, :show]
    resources :users, only: [:index, :show]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
