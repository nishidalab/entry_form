Rails.application.routes.draw do
  root 'static_pages#home'

  # アカウント登録用ページ(for 実験参加者)
  get  '/register', to: 'participants#new'
  post '/register', to: 'participants#create'

  # 被験者マイページ
  get   '/mypage',      to: 'participants#show'

  # 被験者設定ページ
  get   '/settings',  to: 'participants#edit'
  patch '/settings',  to: 'participants#update'
  put   '/settings',  to: 'participants#update'

  # 被験者アカウント削除ページ
  delete '/deactivate', to: 'participants#destroy'

  # 認証ページ(for 実験参加者)
  get    '/login',  to: 'sessions#new_participant'
  post   '/login',  to: 'sessions#create_participant'
  delete '/logout', to: 'sessions#destroy_participant'
  get    '/participant/login', to: redirect('/login')

  # 実験応募ページ
  resources :applications

  # カレンダー確認ページ
  get   '/calendar', to: 'calendar#index'

  # アカウント登録用ページ(for 実験者)
  get  '/member/register', to: 'members#new'
  post '/member/register', to: 'members#create'

  # アカウント有効化ページ(for 被験者)
  get '/activate', to: 'participant_activations#edit'

  # 問い合わせフォーム(for 被験者)
  get  '/inquiries',     to: 'inquiries#index'
  post '/inquiries/new', to: 'inquiries#create'
  get  '/inquiries/new', to: 'inquiries#new'
  #get  '/inquire/:id', to: 'inquiries#show', as: 'inquiry'

  # パスワードリセットフォーム(for 被験者)
  get    '/reset',     to: 'participant_password_resets#new'
  post   '/reset',     to: 'participant_password_resets#create'
  get    '/reset/:id', to: 'participant_password_resets#edit',   as: 'edit_reset'
  patch  '/reset/:id', to: 'participant_password_resets#update', as: 'update_reset'

  # 実験者マイページ
  get   '/member/mypage',      to: 'members#show'
  #get   '/member/mypage/edit', to: 'members#edit'
  #patch '/member/mypage/edit', to: 'members#update'
  #put   '/member/mypage/edit', to: 'members#update'

  # 認証ページ(for 実験者)
  get    '/member/login',  to: 'sessions#new_member'
  post   '/member/login',  to: 'sessions#create_member'
  delete '/member/logout', to: 'sessions#destroy_member'

  # 実験募集ページ
  resources :experiments

  # アカウント有効化ページ(for 実験者)
  get '/member/activate', to: 'member_activations#edit'

  # パスワードリセットフォーム(for 実験者)
  get    '/member/reset',     to: 'member_password_resets#new'
  post   '/member/reset',     to: 'member_password_resets#create'
  get    '/member/reset/:id', to: 'member_password_resets#edit',   as: 'member_edit_reset'
  patch  '/member/reset/:id', to: 'member_password_resets#update', as: 'member_update_reset'

  # admin付与ページ
  get    '/member/approve',     to: 'approve_members#show'
  patch  '/member/approve/:id', to: 'approve_members#update', as: 'update_member_admin'

end
