class Supply::OrdersController < BaseController
  def index
    @orders = current_user.company.orders
  end
end
