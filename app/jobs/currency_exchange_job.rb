class CurrencyExchangeJob
  @queue = :currency_exchange_queue
  @@redis_service=Redis::RedisDaoService.new
  require 'json'
  require 'open-uri'
  require 'net/http'
  def self.perform
    begin
      uri = URI.parse('http://www.apilayer.net/api/live?access_key=b2e657bdbdf751f55b131a760bb33c2a&base=USD')
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      response=JSON.parse(response.body)
      response=response['quotes']
      puts response
      currency=Hash.new
      response.each do |key,value|
        currency=currency.merge({key=>value})
      end
      key_name="currency_exchange"
      currency_data=ConfigConstants::CURRENCY_MAP.each_with_object({}) {|(k,v), h| h[k] = currency[v] if currency.has_key?(v) }
      currency_data.each do |key,value|

        exchange_rate=@@redis_service.get_hashset_data(key_name,key)

        if exchange_rate==nil
          @@redis_service.set_hashset(key_name,key,value)
        else
          if exchange_rate.to_f >value
          else
            @@redis_service.set_hashset(key_name,key,value)
          end
        end

      end


    rescue Exception => e
      puts "Cmp add event Exception = #{e.message}"
    end
end

end