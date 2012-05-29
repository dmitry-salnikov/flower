# encoding: UTF-8
require_relative 'sound_command'
class Laughter < SoundCommand
  respond_to "hähä", "giggle", "haha", "hoho", "muhaha", "mouhaha"

  def self.description
    "laughter"
  end

  def self.respond(command, message, sender, flower)
    case command
    when "hähä"
      play_file "hehe.mp3"
    when "giggle"
      play_file "giggle.mp3"
    when "hoho"
      play_file "hoho.mp3"
    when "haha"
      play_file "haha.wav"
    else
      play_file "muhaha.mp3"
    end
  end
end