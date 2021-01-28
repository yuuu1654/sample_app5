Rails.application.routes.draw do
  get 'static_pages/home'
  # => StaticPages#home
  
  get 'static_pages/help'
  # => StaticPages#help
  
  get 'static_pages/about'
  root 'static_pages#home'
end
