Rails.application.routes.draw do
  resources :on_specials
  resources :dont_sells
  devise_for :users, controllers: { registrations: "users/registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#show'
end
