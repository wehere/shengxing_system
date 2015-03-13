class Supply::OrderItemsController < BaseController
  before_filter :need_login

  def edit
    @order_item = OrderItem.find(params[:id])
  end

  def update
    puts params
    @order_item = OrderItem.find(params[:id])
    @order_item.update_attribute :plan_weight, params[:order_item_modal_plan_weight]
    @order_item.update_attribute :real_weight, params[:order_item_modal_real_weight]
    @order_item.change_price params[:order_item_modal_price]
    @order_item.update_money
  end

  def search
    supplier_id = current_user.company.id
    @customers = current_user.company.customers
    if request.post?
      @product_name = params[:product_name]
      @start_date = params[:start_date]
      @end_date = params[:end_date]
      @customer_id = params[:customer_id]
      @order_items = OrderItem.query_order_items params[:product_name], params[:start_date], params[:end_date], params[:customer_id], supplier_id
    else
      @product_name = ''
      @start_date = Time.now.to_date - 30.days
      @end_date = Time.now.to_date
      @customer_id = nil #current_user.company.customers.first.id
      @order_items = nil
    end
  end

  def null_price
    supplier_id = current_user.company.id
    @order_items = OrderItem.find_null_price supplier_id
  end

  def make_up_price

  end

end