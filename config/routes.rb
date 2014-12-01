Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  # 超级管理员
  namespace :sp do
    resources :companies
    resources :prices
  end

  # 公司管理员
  namespace :ad do

  end

  # 游客
  namespace :vis do

  end

  # 公司的客户
  namespace :cs do

  end
end
