class Purchase::OrdersController < BaseController
  def index
    @orders = current_user.company.in_orders
  end
end
