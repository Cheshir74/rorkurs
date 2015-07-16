Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  resources :questions do
    resources :answers, shallow: true, only: [:new, :create, :destroy, :update] do
        post :set_best, on: :member
    end
  end
end
