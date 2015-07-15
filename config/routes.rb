Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  resources :questions do
    resources :answers, only: [:new, :create, :destroy, :best, :update]
  end
  patch 'answers/:id/set_best' => 'answers#set_best', as: :set_best
end
