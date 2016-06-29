Rails.application.routes.draw do
  resources :basic_resources, except: [:new, :edit] do
    resources :components, except: [:new, :edit] do
      collection do
        get 'status'
      end
      member do
        get 'collect/:capability', to: "components#collect_specific"
        get 'collect', to: "components#collect"
        put 'actuate/:capability', to: "components#actuate"
      end
    end
  end

  get 'manager/status', to: "components_manager#status_all"
  get 'manager/status/:component_id', to: "components_manager#status"
  get 'manager/start', to: "components_manager#start_all"
  get 'manager/start/:component_id', to: "components_manager#start"
  get 'manager/stop', to: "components_manager#stop_all"
  get 'manager/stop/:component_id', to: "components_manager#stop"

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
