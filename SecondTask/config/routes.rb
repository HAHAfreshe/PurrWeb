Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'users', controllers: {
    sessions: 'overrides/sessions'
  }
  resources :users, only: [:index, :show]do
    resources :columns do
      resources :cards, shallow: true do
        resources :comments
      end
    end
  end
end
