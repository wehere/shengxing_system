class GeneralProduct < ActiveRecord::Base
  belongs_to :seller
  belongs_to :company, foreign_key: :supplier_id
  has_many :products

  def self.create_general_product params, supplier_id
    self.transaction do
      general_product = self.new name: params[:name], seller_id: params[:seller_id], supplier_id: supplier_id
      general_product.save!
      general_product
    end
  end

  def update_general_product params
    GeneralProduct.transaction do
      self.update_attribute :name, params[:name] unless params[:name].blank?
      self.update_attribute :seller_id, params[:seller_id] unless params[:seller_id].blank?
      self
    end
  end
end
