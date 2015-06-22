Rails.application.routes.draw do

  root to: 'pages#index', as:'root'
  get 'friends/index', as: 'user_root'

  devise_for :users
  resources :friends, only:[:index, :create, :update, :destroy,:show]
  resources :images, only: [:create]
  resources :agents, only: [:create, :update]
  resources :froms, only: [:create, :update]
  resources :messages, only: [:create, :update]
  resources :reasons, only: [:create, :update]
  resources :events, only: [:create, :update, :destroy,:show]
  resources :letters, only: [:create, :update, :destroy,:show]
  resources :pages, only: [:index, :create, :update]
  put 'page', to: 'pages#change'
  get '*path', to: 'pages#index'


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
