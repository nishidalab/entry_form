Rails.application.routes.draw do
  root 'static_pages#home'

  # アカウント登録用ページ
  get   '/register', to: 'participants#new'
  post  '/register', to: 'participants#create'
end
