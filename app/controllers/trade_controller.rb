class TradeController < BaseController
  layout false
  def new_condition

  end

  def create_condition
    Condition.create_ noble_metal_id: params[:noble_metal_id], relation: params[:relation], value: params[:value]
    redirect_to action: :conditions
  end

  def conditions
    @conditions = Condition.all
  end

  def edit_condition
    @condition = Condition.find params[:id]
  end

  def update_condition
    Condition.find(params[:id]).update_ relation: params[:relation], value: params[:value]
    redirect_to action: :conditions
  end

end