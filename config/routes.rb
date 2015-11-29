Rails.application.routes.draw do

  devise_for :users
  resources :filterspams do
    resources :likes
    resources :comments
  end

  root 'filterspams#index'

end
