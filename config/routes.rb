Rails.application.routes.draw do
  get 'sessions/new'

  root 'static_pages#home'

  # アカウント登録用ページ(for 被験者)
  get  '/register', to: 'participants#new'
  post '/register', to: 'participants#create'

  # 被験者マイページ
  get   '/mypage',      to: 'participants#show'
  get   '/mypage/edit', to: 'participants#edit'
  patch '/mypage/edit', to: 'participants#update'
  put   '/mypage/edit', to: 'participants#update'

  # 認証ページ
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # 実験応募ページ
  resources :applications

  # カレンダー確認ページ
  get   '/calendar', to: 'calendar#index'

  # アカウント登録用ページ(for 実験者)
  get  '/member/register', to: 'members#new'
  post '/member/register', to: 'members#create'

end
