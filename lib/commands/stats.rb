# encoding: utf-8
class Stats < Flower::Command
  respond_to "stats"
  CHARTBEAT_URL = "http://api.chartbeat.com"

  def self.respond(command, message, sender, flower)
    message_array = message.split(" ")
    case message_array.first
    when "online"
      flower.say("Online right now: #{online_right_now}")
    when "commands"
      nick = message_array[1] || sender[:nick]
      flower.say "Commands stats for #{nick}"
      flower.paste command_stats_for(nick)
    when "sax"
      nick = message_array[1] || sender[:nick]
      flower.say "Sax stats for #{nick}"
      flower.paste sax_stats_for(nick)
    else
      flower.say("Online right now: #{online_right_now}")
    end
  end

  def self.description
    "Online right now"
  end

  private

  def self.command_stats_for(nick)
    stats = Flower::Stats.find("commands/#{nick.downcase}", 1.hours.ago, 1.hour.from_now).total.reject{|v| v == "!"}
    stats.map {|type, value| "#{type}: #{value}"} << "totalt: #{stats.values.inject(:+) || 0}"
  end

  def self.sax_stats_for(nick)
    stats = Flower::Stats.find("sax/#{nick.downcase}", 1.hours.ago, 1.hour.from_now).total
    stats.map {|type, value| "#{type}: #{value}"} << "totalt: #{stats.values.inject(:+) || 0}"
  end

  def self.online_right_now
    require 'open-uri'
    doc = open "#{CHARTBEAT_URL}/quickstats?host=#{Flower::Config.chartbeat['domain']}&apikey=#{Flower::Config.chartbeat['key']}"
    json = JSON.parse doc.read
    json["people"]
  end
end
