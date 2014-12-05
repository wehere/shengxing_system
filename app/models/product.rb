class Product < ActiveRecord::Base
  validates_presence_of :simple_abc, :message => '中文缩写不可以为空！'
end
