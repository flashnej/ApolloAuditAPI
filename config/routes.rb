Rails.application.routes.draw do
  root 'welcome#index'

  namespace :api do
    namespace :v1 do
      resources :projects, only: [:index, :create, :show]
    end
  end
end
