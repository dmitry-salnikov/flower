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
    stats = find("commands/#{nick.downcase}", 1000.days.ago, 1.hour.from_now).total.reject{|v| v.blank? }
    sorted(stats)
  end

  def self.leaderboard
    current  = sorted(find("leaderboard", 1000.days.ago, 1.hour.from_now).total).to_a
    previous = sorted(find("leaderboard", 1000.days.ago, 1.week.ago).total).to_a

    current.map do |nick, value|
      [nick, value, calculate_diff(current, previous, [nick, value])]
    end
  end

  private

  def self.sorted(stats)
    stats.sort{ |a,b| b.last <=> a.last }
  end

  def self.calculate_diff(current, previous, obj)
    previous_obj = previous.find{ |key, value| obj.first == key }
    (current.index(obj) - previous.index(previous_obj)) * -1
  end
end
