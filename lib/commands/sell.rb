# encoding: UTF-8
require_relative 'sound_command'
class Sell < SoundCommand
  respond_to "sell"

  FILES = Dir.glob("extras/sell/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "ABC - Always Be Closing!"
  end

  def self.respond(command, message, sender, flower)
    play_file FILES.sample
  end
end