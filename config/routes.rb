Rails.application.routes.draw do
  root :to => 'home#index'
  get 'home', to: 'home#index', as: :home
  get 'app', to: 'app#index', as: :app
  get 'home/index'
  get 'app/index'

  get 'auth/signin'
  post 'auth/signin', to: 'auth#signin_post'
  get 'auth/signout'
  post 'auth/signout'
  get 'user/create'
  post 'user/create', to: 'user#post'
  get 'user/confirm_email/:confirmation' => 'user#confirm_email', as: :confirm_email

  get 'site/about'
  get 'site/tos'
  get 'site/privacy'

  get 'auth/reset_pw'
  post 'auth/reset_pw', to: 'auth#reset_pw_post'

  get 'user/edit'
  post 'user/edit', to: 'user#put'
  get 'user/change_pw'
  post 'user/change_pw', to: 'user#change_pw_post'
  get 'user/change_email'
  post 'user/change_email', to: 'user#change_email_post'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
