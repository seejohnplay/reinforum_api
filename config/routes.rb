Rails.application.routes.draw do
  resources :categories, only: :index

  resources :posts, except: [:new]

  get ':category/posts', to: 'posts#by_category'
  post '/posts/:id', to: 'posts#update_vote_score'
end
