Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  scope :games do
    resources :top_trumps, only: [:index, :create, :show] do
      resources :moves, only: [:create, :update]
    end
  end

end
