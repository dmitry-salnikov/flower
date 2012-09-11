# encoding: UTF-8
require_relative 'sound_command'
class LaggUt < SoundCommand
  respond_to "laggut", "läggut"
  listen_to /deploy/i

  FILES = Dir.glob("extras/laggut/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "Lägg ut!"
  end

  def self.respond(command, message, sender, flower)
    play_file FILES.sample
  end

  def self.listen(message, sender, flower)
    respond("läggut", message, sender, flower)
  end
end