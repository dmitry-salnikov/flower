# encoding: UTF-8
require_relative 'sound_command'
class Trololol < SoundCommand
  respond_to "trololol"

  FILES = Dir.glob("extras/trololol/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "Trololol!"
  end

  def self.respond(command, message, sender, flower)
    play_file FILES.sample
  end
end