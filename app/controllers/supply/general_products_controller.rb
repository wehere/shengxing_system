class Supply::GeneralProductsController < BaseController
  before_filter :need_login

  def index
    @general_products = current_user.company.general_products
  end

  def new
    @general_product = ::Supply::GeneralProduct.new
    @sellers = current_user.company.sellers
    @seller = @sellers.first
  end

  def create
    params.permit!
    begin
      GeneralProduct.create_general_product params, current_user.company.id
      flash[:notice] = '产品创建成功。'
      redirect_to supply_general_products_path
    rescue Exception=>e
      flash[:alert] = dispose_exception e
      @general_product = GeneralProduct.new params
      @sellers = current_user.company.sellers
      @seller = @general_product.seller
      render :new
    end
  end

  def edit
    begin
      @general_product = GeneralProduct.find(params[:id])
      @sellers = current_user.company.sellers
      @seller = @general_product.seller
    rescue Exception=>e
      flash[:alert] = dispose_exception e
      redirect_to supply_general_products_path
    end
  end

  def update
    params.permit!
    begin
      GeneralProduct.find(params[:id]).update_general_product params
      flash[:notice] = '产品修改成功。'
      redirect_to supply_general_products_path
    rescue Exception=>e
      flash[:alert] = dispose_exception e
      @general_product = GeneralProduct.new params
      @sellers = current_user.company.sellers
      @seller = @general_product.seller
      render :edit
    end
  end

  def destroy

  end

end
