Rails.application.routes.draw do
  resources :users do
    
  end
  
  resources :sessions do
    
  end
  
  resources :tops do
    
  end
  
  resources :favorites, only: [:create, :destroy]
  
  resources :webpages do
  end
  
  get '/blogs', to: 'blogs#index'
  
  resources :blogs do
    collection do
      post :confirm
    end
  end
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

end
