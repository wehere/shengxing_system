class Supply::SellersController < BaseController
  before_filter :need_login

  def index
    @sellers = current_user.company.sellers
  end

  def new
    @seller = Seller.new
  end

  def create
    begin
      Seller.create_seller seller_params, current_user.company.id
      flash[:notice] = '创建卖家成功。'
      redirect_to supply_sellers_path
    rescue Exception=>e
      flash[:alert] = dispose_exception e
      @seller = Seller.new seller_params
      render :new
    end
  end

  def update
    begin
      Seller.find(params[:id]).update_seller seller_params
      flash[:notice] = '修改卖家信息成功。'
      redirect_to supply_sellers_path
    rescue Exception=>e
      flash[:alert] = dispose_exception e
      @seller = Seller.new seller_params
      render :edit
    end
  end

  def edit
    begin
      @seller = Seller.find(params[:id])
    rescue Exception=>e
      flash[:alert] = dispose_exception e
      render :index
    end
  end

  private
    def seller_params
      params.permit(:name, :shop_name, :phone, :address)
    end

end