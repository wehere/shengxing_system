class Condition < ActiveRecord::Base

  RELATION = {
      1 => '大于等于',
      2 => '等于',
      3 => '小于等于'
  }

  belongs_to :noble_metal

  scope :is_valid, -> { where is_valid: true }

  # 创建condition
  # Condition.create_
  def self.create_ options
    self.create! noble_metal_id: options[:noble_metal_id],
                 relation: options[:relation],
                 value: options[:value]
  end

  # 更新condition
  # Condition.update_
  def update_ options
    self.relation = options[:relation]
    self.value = options[:value]
    self.save!
  end

  # 判断是否符合条件
  def conform? prices
    price = prices[noble_metal.code]
    case relation
      when 1
        price >= value
      when 2
        price == value
      when 3
        price <= value
    end
  end

end