# encoding: utf-8
require 'typhoeus'
class SL < Flower::Command
  respond_to 'sl'

  class << self
    def description
      'SL from Stockholm Södra, use buses/trains as message'
    end

    def respond(message)
        transport = "Buses"
        station = 9530
        response = nil
        if message.argument == "trains"
          transport = "Trains"
        end
        response = get_station(station)
        items = get_result(response["DPS"][transport].first[1])
        message.paste(items, :mention => message.user_id)
    end

    private
    def get_station(station)
      url = "https://api.trafiklab.se/sl/realtid/GetDpsDepartures.json?key=#{Flower::Config.api_sl}&siteId=#{station}"
      items = JSON.parse(Typhoeus::Request.get(url).body)
    end

    def get_result(items)
      items.map!{|item| item["Destination"] + " - " + item["DisplayTime"] }
    end
  end
end