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
    stats = find("commands/#{nick.downcase}", 365.days.ago, 1.hour.from_now).total.reject{|v| v.blank? }
    sorted(stats)
  end

  def self.leaderboard
    sorted(find("leaderboard", 365.days.ago, 1.hour.from_now).total)
  end

  private

  def self.sorted(stats)
    stats.sort{ |a,b| b.last <=> a.last }
  end
end
