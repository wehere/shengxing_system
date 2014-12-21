Rails.application.routes.draw do

  devise_for :users
  root 'vis/static_pages#welcome'

  # 超级管理员
  namespace :sp do
    resources :companies
    resources :products
    resources :prices do
      collection do
        get :search
        post :search
      end
    end
    resources :orders
  end


  # 供应方
  namespace :supply do

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

  end
end
