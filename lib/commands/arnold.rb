# encoding: UTF-8
require_relative 'sound_command'
class Arnold < SoundCommand
  respond_to "arnold"

  FILES = Dir.glob("extras/arnold/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "Arnold movie quotes"
  end

  def self.respond(message)
    play_file FILES.sample
  end
end