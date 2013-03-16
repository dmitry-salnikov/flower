# encoding: UTF-8
require_relative 'sound_command'
class Job < SoundCommand
  respond_to "job"
  listen_to /[^!]job/i

  FILES = Dir.glob("extras/jobs/*.mp3").map{|f| f.gsub("extras/","")}

  def self.description
    "They took our jobs!"
  end

  def self.respond(message)
    play_file FILES.sample
  end

  def self.listen(message)
    play_file FILES.sample
  end
end