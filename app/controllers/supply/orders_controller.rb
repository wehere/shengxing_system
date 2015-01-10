class Supply::OrdersController < BaseController
  before_filter :need_login
  def index
    @key = params[:key]
    @date_start = params[:date_start].blank? ? Time.now.to_date : params[:date_start]
    @date_end = params[:date_end].blank? ? Time.now.to_date : params[:date_end]
    @orders = current_user.company.in_orders.where("delete_flag is null or delete_flag = 0")
    if !params[:date_start].blank? && !params[:date_end].blank?
      @orders = @orders.where(reach_order_date: params[:date_start]..params[:date_end])
    end
    unless params[:key].blank?
      @orders = @orders.where("id = ? or customer_id = ?", params[:key], params[:key])
    end
    @orders = @orders.paginate(page: params[:page], per_page: 10)
  end

  def edit
    @order = Order.find(params[:id])
    @pre_order = current_user.company.in_orders.valid_orders.where(customer_id: @order.customer_id, store_id: @order.store_id, reach_order_date: @order.reach_order_date - 1.days ).first
    @next_order = current_user.company.in_orders.valid_orders.where(customer_id: @order.customer_id, store_id: @order.store_id, reach_order_date: @order.reach_order_date + 1.days ).first
    @order_items = @order.order_items
  end

  def update
    hash = params[:order_item]
    Order.transaction do
      hash.each do |key,value|
        order_item = OrderItem.find(key)

          order_item.update_attribute :real_weight, value.blank? ? 0 : value
          order_item.update_money
      end
    end
    redirect_to edit_supply_order_path(params[:order_id])
  end

end

# Parameters: {"order_id"=>"80",
# "order_item"=>{"98"=>[""], "99"=>[""], "100"=>[""], "101"=>[""], "102"=>[""], "103"=>[""], "104"=>[""], "105"=>[""], "106"=>[""], "107"=>[""], "108"=>[""]}, "commit"=>"提交", "id"=>"80"}
# User Load (39.5ms)  SELECT  `users`.* FROM `users`  WHERE `users`.`id` = 1  ORDER BY `users`.`id` ASC LIMIT 1