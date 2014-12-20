class BaseController < ApplicationController

  def need_login
    redirect_to welcome_vis_static_pages_path unless user_signed_in?
  end
end