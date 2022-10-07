Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  root "home#index"

  scope :games do
    resources :top_trumps, only: [:index, :create, :show, :update] do
      resources :moves, only: [:create, :update]
      resources :accepts, only: [:create]
    end
  end

end
