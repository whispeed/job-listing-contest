Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  resources :jobs do
    member do
      post :follow
      post :unfollow
    end
    collection do
      get :search
    end
    resources :resumes
  end

  root "welcome#index"

  namespace :admin do
    resources :jobs do
      member do
        post :publish
        post :hide
      end

      resources :resumes
    end
  end

  namespace :account do
    resources :jobs
    resources :resumes
  end
end
