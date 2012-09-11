# encoding: utf-8
require 'typhoeus'
class SL < Flower::Command
  respond_to 'sl'

  class << self
    def description
      'SL from Stockholm Södra'
    end

    def respond(command, message, sender, flower)
      #puts "#{command} #{message} #{sender}"
      flower.paste(bus, :mention => sender[:id])
    end

    private
    def get_station(station)
      items = JSON.parse(Typhoeus::Request.get("http://sjostadsbussen.se/departures/#{station}.json").body)
      items.map!{|item| item["Destination"] + " - " + item["DisplayTime"]}
    end

    def bus
      get_station(9530)
    end

    def train
      get_station(9530)
    end

    def metro
      get_station(9297)
    end
  end
end