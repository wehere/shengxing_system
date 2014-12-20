class Sp::OrdersController < ApplicationController
  def index
    @orders = current_user.company.orders
  end
end
