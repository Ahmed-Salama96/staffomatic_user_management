Rails.application.routes.draw do
  resource :signup, only: %i[create]
  resources :authentications, only: %i[create]
  resources :users, only: %i[index destroy] do
    post 'archive', action: :archive
    post 'unarchive', action: :unarchive
  end
end
