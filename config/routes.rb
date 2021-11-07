Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post 'trucks', to: 'trucks#create'
      get 'truck/:id/summary', to: 'trucks#summary'
      get 'trucks/active', to: 'trucks#active'
      get 'truck/log', to: 'trucks#log'

      # get 'report', to: 'trucks#report'
    end
  end
end
