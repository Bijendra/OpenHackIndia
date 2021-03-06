module Cleartrip
  class << self

    require 'uri'
    require 'json'
    require 'net/http'
    require 'mechanize'

    def flights(from, to, date)
      agent = Mechanize.new { |agent|
        agent.user_agent = "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
      }
      url = "http://www.cleartrip.com/m/flights/results?rnd_one=O&from=#{airport_code(from)}&to=#{airport_code(to)}&depart_date=#{date}&adults=1&childs=0&infants=0&mobile=true&class=Economy&carrier=&dep_time=0&airline_codes=ALL"
      flight_xml = agent.get(url).search(".//div[@class='item']")
      flights = []
      puts flight_xml.first.children
      flight_xml.each do |f_xml|
        flight = {}
        flight[:name] = f_xml.children.children.first.text
        flight[:time] = f_xml.children[3].children[1].children.first.text
        flight[:date] = f_xml.children[5].children[5].attributes["value"].value
        flight[:cost] = f_xml.children[5].children[21].children[1].children.last.text
        flights << flight
      end
      flights
    end

    private
    def airport_code(city)
      url = "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20json%20where%20url%20%3D%20'http%3A%2F%2Fairportcode.riobard.com%2Fsearch%3Ffmt%3DJSON%26q%3D#{city}'&format=json&diagnostics=true&callback="
      response = Net::HTTP.get(URI.parse(url))
      JSON.parse(response)["query"]["results"]["json"]["code"]
    end

  end
end
