SimplyAuth::Engine.routes.draw do
  resources :registrations
  resource :session
  resource :password
end
