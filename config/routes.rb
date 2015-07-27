Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post 'email_confirmation', to: 'omniauth_callbacks#email_confirmation'
  end
  root to: "questions#index"
  concern :votable do
    resources :votes, only: [:vote_up, :vote_down, :vote_destroy] do
      post :vote_up, on: :collection
      post :vote_down, on: :collection
      post :vote_destroy, on: :collection
    end
  end
  resources :questions, concerns: :votable do
    resources :comments, :defaults => {commentable: 'question'}, only: [:create]

    resources :answers, concerns: :votable, shallow: true, only: [:new, :create, :destroy, :update] do
      resources :comments, :defaults => {commentable: 'answer'}, only: [:create]
        post :set_best, on: :member
    end
  end


  resources :attachments, only: :destroy
end
