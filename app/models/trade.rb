class Trade < ActiveRecord::Base

  APIKEY = '3944403610171942d0bc91b9c45e74b4'
  PHONE = '15021915658'

  # 检查贵金属价格是否符合条件
  # Trade.check
  def self.check
    response = JSON.parse RestClient.post "http://www.tjpme.com/flash/transactiondata.php?rand=1466042206751", {}
    response.delete("all")
    prices = {}
    response.each do |k,v|
      arr = v.gsub("　",",").gsub("  ",",").gsub("最新价：","").gsub("涨幅：","").gsub("%","")        .split(",")
      prices[k] = arr[3].to_f
      noble_metal = NobleMetal.find_by_code k
      nmp = NobleMetalPrice.where noble_metal_id: noble_metal.id,
                                  price: arr[3],
                                  trade_date: arr[0],
                                  trade_time: arr[2],
                                  week: arr[1]
                                  # change_percent: arr[4]
      NobleMetalPrice.create! noble_metal_id: noble_metal.id,
                                         price: arr[3],
                                         trade_date: arr[0],
                                         trade_time: arr[2],
                                         week: arr[1],
                                         change_percent: arr[4] if nmp.blank?
    end
    # platinum = response["platinum"].match(/[：]{1}([\d.]{1,})[　]{1}/)[1]
    # response["platinum"].gsub("　",",").gsub("  ",",").gsub("最新价：","").gsub("涨幅：","").gsub("%","")        .split(",")
    # palladium = response["palladium"].match(/[：]{1}([\d.]{1,})[　]{1}/)[1]
    # sliver = response["sliver"].match(/[：]{1}([\d.]{1,})[　]{1}/)[1]
    # ni = response["ni"].match(/[：]{1}([\d.]{1,})[　]{1}/)[1]
    # cu = response["cu"].match(/[：]{1}([\d.]{1,})[　]{1}/)[1]
    # al = response["al"].match(/[：]{1}([\d.]{1,})[　]{1}/)[1]
    # prices = {
    #     'platinum' => platinum.to_f,
    #     'palladium' => palladium.to_f,
    #     'sliver' => sliver.to_f,
    #     'ni' => ni.to_f,
    #     'cu' => cu.to_f,
    #     'al' => al.to_f
    # }
    Condition.is_valid.each do |condition|
      if condition.conform? prices
        send_phone_message Trade::PHONE, condition.noble_metal.name, prices[condition.noble_metal.code]
        condition.update_attributes is_valid: false
      end
    end
  end

  # 发送通知短信
  # Trade.send_phone_message
  def self.send_phone_message phone, noble_metal, price
    require 'rest-client'
    content = CGI::escape("【朋朋】你好，#{noble_metal}，您的验证码是#{price}，请留意！")
    response = RestClient.get "http://apis.baidu.com/kingtto_media/106sms/106sms?mobile=#{phone}&content=#{content}&tag=2", {:apikey => Trade::APIKEY}
    pp response
  end

end