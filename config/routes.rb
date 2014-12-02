Rails.application.routes.draw do
  devise_for :users
  root 'vis/static_pages#welcome'

  # 超级管理员
  namespace :sp do
    resources :companies
    resources :products
    resources :prices
  end

  # 公司管理员
  namespace :ad do

  end

  # 游客
  namespace :vis do
    resources :static_pages do
      get :welcome
    end
  end

  # 公司的客户
  namespace :cs do

  end
end
