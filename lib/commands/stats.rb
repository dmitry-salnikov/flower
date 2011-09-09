# encoding: utf-8
class Stats < Flower::Command
  respond_to "stats"
  CHARTBEAT_URL = "http://api.chartbeat.com"
  
  def self.respond(command, message, sender, flower)
    case message
    when "online"
      say_online
    else
      say_online
    end
  end

  def self.description
    "Online right now"
  end

  def say_online
    flower.say("Online right now: #{online_right_now}")
  end

  private
  # stats
  def self.online_right_now
    require 'open-uri'
    doc = open "#{CHARTBEAT_URL}/quickstats?host=#{Flower::Config.chartbeat['domain']}&apikey=#{Flower::Config.chartbeat['key']}"
    json = JSON.parse doc.read
    json["people"]
  end
end
