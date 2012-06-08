Recipes::Application.routes.draw do
  root :to => 'users#index'
  get "sessions/new"
  get "users/new"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  match '/auth/:provider/callback', :to => 'sessions#omni'
  match '/auth/failure', :to => 'sessions#failure'

  resources :users do
    member do
      get 'recipes'
    end
    resources :recipes
  end
  resources :sessions
  resources :ingredients do
    member do
      get 'recipes'
    end
  end
  
  resources :recipes

  scope '/recipes' do
    match '/:name' => 'recipes#show'
    match '/:id/update_rating', :controller => 'recipes', :action => 'update_rating'
    match '/new/render_ingredients_input', :controller => 'recipes', :action => 'render_ingredients_input'
    match '/:id/render_ingredients_input', :controller => 'recipes', :action => 'render_ingredients_input'
  end

  match '/user' => 'users#me'
  #match '/recipes/:name', :controller => 'recipes', :action => 'show'
  match '/ingredients/:name' => 'ingredients#show'
  
  #match '/:email', :controller => 'users', :action => 'edit'
  match '/me' => 'users#me'
end
