Penunsen::Application.routes.draw do
  resources :accounts do
    resources :statements
  end
  root :to => "accounts#index"
end
