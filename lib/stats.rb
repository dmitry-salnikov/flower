# encoding: UTF-8
require 'redistat'

class Flower::Stats
  include Redistat::Model

  def self.store_command_stat(message)
    store("commands/#{message.sender[:nick].downcase}", {message.command => 1}) if message.command
  rescue
    puts "REDIS ERROR"
  end

  def self.store_leaderboard_stat(message)
    store("leaderboard", {message.sender[:nick] => 1})
  rescue
    puts "REDIS ERROR"
  end

  def self.command_stats_for(nick)
    stats = find("commands/#{nick.downcase}", 1000.days.ago, 1.hour.from_now).total
    stats = stats.to_a.map {|x| [x.first.dup.force_encoding("UTF-8"), x.last] }
    stats.reject!{|v| v.blank? }
    sort_list(stats)
  end

  def self.leaderboard
    current  = sorted_leaderboard
    previous = sorted_leaderboard(1.week.ago)

    current.map do |nick, value|
      [nick, value, calculate_diff(current, previous, [nick, value])]
    end
  end

  private

  def self.sorted_leaderboard(to_date = 1.hour.from_now)
    sort_list(find("leaderboard", 1000.days.ago, to_date).total).to_a
  end

  def self.sort_list(stats)
    stats.sort{ |a,b| b.last <=> a.last }
  end

  def self.calculate_diff(current, previous, obj)
    previous_obj = previous.find{ |key, value| obj.first == key }
    (current.index(obj) - previous.index(previous_obj)) * -1
  end
end
