Rails.application.routes.draw do
  devise_for :users, skip: [:sessions, :registrations]
  
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post 'signup', to: 'registrations#create'
        post 'login', to: 'sessions#create'
        delete 'logout', to: 'sessions#destroy'
      end

      get 'profile', to: 'users#profile'
    end
  end
end
