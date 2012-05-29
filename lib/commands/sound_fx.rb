# encoding: UTF-8
require_relative 'sound_command'
class SoundFx < SoundCommand
  respond_to "easy", "friday", "rimshot", "sad", "yeah", "hähä", "airwolf", "ateam", "applause", "giggle", "bomb", "suprise", "haha", "hoho", "snore", "muhaha", "godwillsit", "sting", "*","**", "***", "****", "death", "khan"

  def self.description
    "Awesome audio fx!"
  end

  def self.respond(command, message, sender, flower)
    case command
    when "easy"
      play_file "easy.mp3"
    when "friday"
      if Time.now.wday == 5
        play_file("friday.mp3")
      else
        flower.say("Today != rebeccablack", :mention => sender[:id])
      end
    when "rimshot"
      play_file "rimshot.mp3"
    when "sad"
      play_file "sadtrombone.mp3"
    when "yeah"
      play_file "yeah.mp3"
    when "hähä"
      play_file "hehe.mp3"
    when "airwolf"
      play_file "airwolf.m4a"
    when "ateam"
      play_file "a_team.m4a"
    when "applause"
      play_file "applause.mp3"
    when "giggle"
      play_file "giggle.mp3"
    when "bomb"
      play_file "bomb.mp3"
    when "suprise"
      play_file "suprise.m4r"
    when "hoho"
      play_file "hoho.mp3"
    when "haha"
      play_file "haha.wav"
    when "snore"
      play_file "snore.wav"
    when "muhaha"
      play_file "muhaha.mp3"
    when "godwillsit"
      play_file "godwillsit.m4a"
    when "sting"
      play_file "sting.wav"
    when "death"
      play_file "death.wav"
    when "khan"
      play_file "khan.wav"
    when /\**/
      Spotify.lower_spotify do
        count = command.scan(/\*/).size.times do |i|
          if i <= 2
            play_file "lightning_bolt.wav", false
          else
            play_file "death.wav", false
          end
        end
      end
    end
  end
end