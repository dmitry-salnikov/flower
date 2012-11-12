# encoding: UTF-8
require_relative 'sound_command'
class Sax < SoundCommand
  respond_to "sax"

  def self.description
    "Epic sax"
  end

  def self.respond(command, message, sender, flower)
    if rand(100) == 1
      store_stats(sender, :retro)
      play_file "sax/retrosaxguy.m4a"
    else
      store_stats(sender, :original)
      play_file "sax/epicsaxguy.m4a"
    end
  end

  private

  def self.store_stats(sender, type)
    Flower::Stats.store("sax/#{sender[:nick].downcase}", {type => 1})
  end
end