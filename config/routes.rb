Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "pages#home"

  resources :stocks do
    collection do
      get :engulfing_pattern_action
      get :three_bar_breakout_action
    end
  end
  resources :mentions 
end
