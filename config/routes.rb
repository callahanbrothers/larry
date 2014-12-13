Rails.application.routes.draw do
  root 'home#new'
  get "/auth/twitter/callback", to: "sessions#create"
  delete "sign-out", to: "sessions#destroy"
end
