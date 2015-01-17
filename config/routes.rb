Rails.application.routes.draw do

  devise_for :users
  root 'vis/static_pages#welcome'

  # 超级管理员
  namespace :sp do
    resources :companies
    resources :products
  end


  # 供应方
  namespace :supply do
    resources :home, only: [:index]
    resources :products do
      collection do
        post :index
      end
    end
    resources :prices do
      collection do
        get :search
        post :search
        get :generate_next_month
        post :generate_next_month
        get :import_prices_from_xls
        post :import_prices_from_xls
        get :export_xls_of_prices
      end
      member do
        post :export_xls_of_prices
      end
    end
    resources :orders do
      collection do
        post :index
        post :comment
      end
    end
  end

  # 游客
  namespace :vis do
    resources :static_pages do
      collection do
        get :welcome
      end
    end
  end

  # 采购方
  namespace :purchase do
    resources :home, only: [:index]
    resources :products
    resources :prices do
      collection do
        get :search
        post :search
      end
    end
    resources :orders do
      collection do
        post :send_message
        post :index
        post :comment
      end
    end
  end
end
