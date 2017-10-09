Rails.application.routes.draw do
  resources :categories, only: :index

  resources :posts, only: :index

  get ':category/posts', to: 'posts#by_category'
end
