Rails.application.routes.draw do
  root 'chords#index'
  resources :chords
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
