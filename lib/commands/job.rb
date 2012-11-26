# encoding: UTF-8
require_relative 'sound_command'
class Job < SoundCommand
  respond_to "job"

  FILES = Dir.glob("extras/jobs/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "They took our jobs!"
  end

  def self.respond(command, message, sender, flower)
    play_file FILES.sample
  end

  def self.listen(message, sender, flower)
    play_file FILES.sample
  end
end
