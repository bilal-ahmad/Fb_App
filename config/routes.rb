FacebookApp::Application.routes.draw do
  resources :events

  get "events/index"

  get "events/show"

  get "events/edit"

  get "events/update"

  get "events/create"

  get "events/new"

  resources :social_posts

  resources :settings

  resources :social_apps

  resources :profiles

  get "sessions/index"

  get "sessions/new"

  get "sessions/create"

  get "profiles/new"

  get "profiles/create"

  get "profiles/show"

  get "profiles/index"

 devise_for :users, :controllers => { :registrations => 'registrations',
                                      :sessions => 'sessions',
                                      :confirmations => 'confirmations',
                                      :passwords => 'passwords'}

 devise_for :admins, :controllers => { :registrations => 'admin/registrations',
                                       :sessions => 'admin/sessions',
                                       :confirmations => 'admin/confirmations',
                                       :passwords => 'admin/passwords'}

  resources :authentications

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  match '/auth/:provider/callback' => 'authentications#create'
  match '/auth/:app_name' => 'authentications#facebook_authorize'
  match '/auth/:app_name/index' => 'home#index'
  match '/auth/:app_name/create' => 'authentications#create'
  match '/post_to_facebook' => 'user_social_accounts#post_to_facebook'
  match '/de_authorize_facebook_app' => 'authentications#de_authorize_facebook_app'
  match '/new_photo_post' => 'social_posts#new_photo_post', :as => :new_photo_post
  match '/photo_post' => 'social_posts#photo_post'
  match '/edit_welcome_post' => 'social_posts#edit_welcome_post', :as => :edit_welcome_post
  match '/edit_default_post' => 'social_posts#edit_default_post', :as => :edit_default_post
  match '/update_welcome_post' => 'social_posts#update_welcome_post', :as => :update_welcome_post
  match '/update_default_post' => 'social_posts#update_default_post', :as => :update_default_post
  match '/post' => 'social_posts#post', :as => :post
  match 'validate_user' => 'home#validate_user', :as => :validate_user
  match 'post_to_wall' => 'social_posts#ajax_post', :as => :post_to_wall
  match '/activate_event/:id' => 'events#activate_event', :as => :activate_event
  match 'facebook_error/:error' => 'social_apps#facebook_error', :as => :facebook_error

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  devise_scope :user do
    get "/users/sign_up", :to => "sessions#new"
  end
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
