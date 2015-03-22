class Seller < ActiveRecord::Base
  has_many :general_products
  belongs_to :company, foreign_key: :supplier_id

  validates_presence_of :name, message: '卖家名字不能为空。'

  def self.create_seller params, supplier_id
    self.transaction do
      seller = self.new name: params[:name], shop_name: params[:shop_name], phone: params[:phone],
                   address: params[:address], supplier_id: supplier_id
      seller.save!
      seller
    end
  end

  def update_seller params
    Seller.transaction do
      self.update_attribute :name, params[:name] unless params[:name].blank?
      self.update_attribute :shop_name, params[:shop_name] unless params[:shop_name].blank?
      self.update_attribute :phone, params[:phone] unless params[:phone].blank?
      self.update_attribute :address, params[:address] unless params[:address].blank?
      self.update_attribute :supplier_id, params[:supplier_id] unless params[:supplier_id].blank?
      self
    end
  end

end
