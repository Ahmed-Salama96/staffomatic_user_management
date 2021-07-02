Rails.application.routes.draw do
  resource :signup, only: %i[create]
  resources :authentications, only: %i[create]
  resources :users, only: %i[index destroy]

  scope(controller: 'users') do
    post 'users/archive/:id', action: :archive, as: :archive_user
    post 'users/unarchive/:id', action: :unarchive, as: :unarchive_user
  end
end
