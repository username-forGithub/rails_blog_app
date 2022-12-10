Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    root to: 'devise/sessions#new'    
  end
  # root to: "users#index"

  resources :users, only: [:index, :show] do 
    resources :posts, only: [:index, :show, :new, :create, :destroy] do 
      resources :comments, only: [:new, :create, :destroy]
      resources :likes, only: [:create]
    end
  end

  # API routes
  namespace :api do
    namespace :v1 do
      post 'users/login' => 'users#login'
      get  'user/posts' => 'posts#list_posts'
      get  'user/post/comments' => 'posts#list_comments'
      post 'user/post/new_comment' => 'posts#add_comment'
      resources :users, only: [:index, :show]
    end
  end
  
end
