Rails.application.routes.draw do
  resources :tops do
  end
  
  resources :webpages do
  end
  
  get '/blogs', to: 'blogs#index'
  
  resources :blogs do
    collection do
      post :confirm
    end
  end
end
