class Supply::CustomersController < BaseController
  before_filter :need_login
  def index
    @customers = current_user.company.customers
  end

  def new
    @customer = Company.new
  end

  def create
    begin
      customer = current_user.company.create_customer params[:company].permit(:simple_name, :full_name, :phone, :address)
      flash[:notice] = "创建成功！"
      redirect_to supply_customers_path
    rescue Exception=> e
      flash[:alert] = dispose_exception e
      @customer = Company.new params[:company].permit(:simple_name, :full_name, :phone, :address)
      render :new
    end
  end
end