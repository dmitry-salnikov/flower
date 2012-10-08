require 'redistat'

class Flower::Stats
  include Redistat::Model

  def self.store_command_stat(command, nick)
    store("commands/#{nick.downcase}", {command => 1})
  end

  def self.store_leaderboard_stat(nick)
    store("leaderboard", {nick => 1})
  end

  def self.command_stats_for(nick)
    find("commands/#{nick.downcase}", 365.days.ago, 1.hour.from_now).total.reject{|v| v.blank? }
  end

  def self.leaderboard
    find("leaderboard", 365.days.ago, 1.hour.from_now).total
  end
end
