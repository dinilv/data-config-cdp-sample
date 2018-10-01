class Config::OperatorSyncService < ApplicationService

@@redis=Redis::RedisDaoService.new
  require 'json'
  require 'open-uri'
  require 'net/http'

  @@header = {'Content-Type'=> 'application/json'}
  @@eventaddurl = URI.parse('http://api.iiris.io/cmp/config/add-operator')

  def operator_sync(operator_data)
    begin
      http = Net::HTTP.new(@@eventaddurl.host, @@eventaddurl.port)
      request = Net::HTTP::Post.new(@@eventaddurl.request_uri, @@header)
      request.body = operator_data
      response = http.request(request)
      puts response
    rescue Exception => e
      puts "operator sync error = #{e.message}"
    end
  end

  def self.set_time_zone

    uri = URI.parse('http://localhost')
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    response=JSON.parse(response.body)
    puts "ss"

  end


end