Recipes::Application.routes.draw do
  root :to => 'users#index'
  get "sessions/new"
  get "users/new"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  match '/auth/:provider/callback', :to => 'sessions#omni'
  match '/auth/failure', :to => 'sessions#failure'
  post '/users/activate' => 'users#activate'
  resources :users do
    member do
      get 'recipes'
      get 'faved_recipes'
    end
    resources :recipes do
      match '/fav' => 'users#favorite'
    end
  end
  resources :sessions
  resources :ingredients do
    member do
      get 'recipes'
    end
  end
  
  resources :recipes do
    match '/fav' => 'recipes#favorite'
  end

  scope '/search' do
    match '/' => 'search#index'
    match '/recipes' => 'search#recipes'
  end

  scope '/recipes' do
    match '/:name' => 'recipes#show'
    match '/:id/update_rating', :controller => 'recipes', :action => 'update_rating'
    match '/new/render_ingredients_input', :controller => 'recipes', :action => 'render_ingredients_input'
    match '/:id/render_ingredients_input', :controller => 'recipes', :action => 'render_ingredients_input'
  end

  scope '/user' do
    match '/' => 'users#me'
    match '/invite' => 'users#invite'
  end
  #match '/recipes/:name', :controller => 'recipes', :action => 'show'
  match '/ingredients/:name' => 'ingredients#show'
  
  #match '/:email', :controller => 'users', :action => 'edit'
  match '/me' => 'users#me'
end
