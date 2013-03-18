# encoding: UTF-8
require_relative 'sound_command'
class Sell < SoundCommand
  respond_to "sell"

  FILES = Dir.glob("extras/sell/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "ABC - Always Be Closing! Boiler Room! Alec Baldwin and Ben Affleck at their best!"
  end

  def self.respond(message)
    if FILES.include? "sell/#{message.argument}.mp3"
      play_file "sell/#{message.argument}.mp3"
    else
      play_file FILES.sample
    end
  end
end