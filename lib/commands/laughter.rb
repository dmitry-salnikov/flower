# encoding: UTF-8
require_relative 'sound_command'
class Laughter < SoundCommand
  respond_to "hähä", "giggle", "haha", "hoho", "muhaha", "mouhaha"

  def self.description
    "laughter"
  end

  def self.respond(message)
    case message.command
    when "hähä"
      play_file "laughter/hehe.mp3"
    when "giggle"
      play_file "laughter/giggle.mp3"
    when "hoho"
      play_file "laughter/hoho.mp3"
    when "haha"
      play_file "laughter/haha.wav"
    else
      play_file "laughter/muhaha.mp3"
    end
  end
end