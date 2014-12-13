Rails.application.routes.draw do
  root 'home#new'
  get "/auth/twitter/callback", to: "sessions#create"
end
