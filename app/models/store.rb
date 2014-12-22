class Store < ActiveRecord::Base
  has_many :orders
  belongs_to :company
end
