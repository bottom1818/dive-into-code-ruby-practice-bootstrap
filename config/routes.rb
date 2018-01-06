Rails.application.routes.draw do
  resources :contacts do
  end
  
  get '/blogs', to: 'blogs#index'
  get '/stocks', to: 'stocks#index' 
  
  resources :blogs do
    collection do
      post :confirm
    end
  end
end
