Rails.application.routes.draw do
  resources :links
  resources :tags

  get '/categories/published', to: 'categories#published'
  resources :categories

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/', to: 'categories#published'
  get '/admin',            to: 'links#admin'
  get '/admin/links',      to: 'links#index'
  get '/admin/categories', to: 'categories#index'
  get '/admin/tags',       to: 'tags#index'

end
