# encoding: utf-8
class Stats < Flower::Command
  respond_to "stats", "leaderboard"
  CHARTBEAT_URL = "http://api.chartbeat.com"

  def self.respond(message)
    if message.command == "leaderboard"
      message.paste(leaderboard_stats)
    else
      case message.argument
      when "online"
        message.paste ["Online right now: #{online_right_now}"]
      when "commands"
        nick = message.sender[:nick]
        message.paste ["Top 10 for #{nick}"] << command_stats_for(nick)
      when "leaderboard"
        message.paste(leaderboard_stats)
      else
        message.say("Online right now: #{online_right_now}")
      end
    end
  end

  def self.description
    "Online right now"
  end

  private

  def self.command_stats_for(nick)
    stats = Flower::Stats.command_stats_for(nick)
    response = stats.map { |type, value| "#{type}: #{value}" }.take(10)
    response << "totalt: #{stats.map{|s| s[1] }.inject(:+) || 0}"
  end

  def self.leaderboard_stats
    stats = Flower::Stats.leaderboard
    response = stats.map { |nick, value, diff| "#{arrow(diff)} #{nick}: #{value}" }
  end

  def self.online_right_now
    require 'open-uri'
    doc = open "#{CHARTBEAT_URL}/quickstats?host=#{Flower::Config.chartbeat['domain']}&apikey=#{Flower::Config.chartbeat['key']}"
    json = JSON.parse doc.read
    json["people"]
  end

  def self.arrow(diff)
    if diff > 0
      diff > 5 ? "↑" : "↗"
    elsif diff < 0
      diff < -5 ? "↓" : "↘"
    else
      "→"
    end
  end
end
