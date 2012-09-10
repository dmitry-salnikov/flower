# encoding: UTF-8
require_relative 'sound_command'
class LaggUt < SoundCommand
  respond_to "laggut", "läggut"

  FILES = Dir.glob("extras/laggut/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "Lägg ut!"
  end

  def self.respond(command, message, sender, flower)
    store_stats(sender, :laggut)
    play_file FILES.sample
  end

  private

  def self.store_stats(sender, type)
    Flower::Stats.store("laggut/#{sender[:nick].downcase}", {type => 1})
  end
end