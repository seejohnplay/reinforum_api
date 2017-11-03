Rails.application.routes.draw do
  resources :categories, only: :index
  get ':category/posts', to: 'posts#by_category'

  resources :posts, except: [:new]
  post '/posts/:id', to: 'posts#update_vote_score'
  get '/posts/:id/comments', to: 'posts#comments'

  resources :comments, only: [:show, :create, :update, :destroy]
  post '/comments/:id', to: 'comments#update_vote_score'
end
