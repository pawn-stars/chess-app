Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resource :dashboard, only: [:show]
  root 'games#index'
  resources :games do
    post 'forfeit', on: :member
    resources :pieces, only: [:index, :update]

  end


end
