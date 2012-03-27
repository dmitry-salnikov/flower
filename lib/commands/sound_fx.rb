# encoding: UTF-8
class SoundFx < Flower::Command
  respond_to "easy", "sax", "friday", "rimshot", "sad", "yeah", "hähä", "airwolf", "ateam", "applause", "giggle", "bomb", "suprise", "haha", "hoho", "snore", "muhaha", "godwillsit", "sting"

  def self.description
    "Awesome audio fx!"
  end

  def self.respond(command, message, sender, flower)
    case command
    when "easy"
      Spotify.lower_spotify do
        play_file "easy.mp3"
      end
    when "sax"
      Spotify.lower_spotify do
        if rand(5) == 1
          play_file "retrosaxguy.m4a"
        else
          play_file "epicsaxguy.m4a"
        end
      end
    when "friday"
      if Time.now.wday == 5
        Spotify.lower_spotify do
          play_file("friday.mp3")
        end
      else
        flower.say("Today != rebeccablack", :mention => sender[:id])
      end
    when "rimshot"
      Spotify.lower_spotify do
        play_file "rimshot.mp3"
      end
    when "sad"
      Spotify.lower_spotify do
        play_file "sadtrombone.mp3"
      end
    when "yeah"
      Spotify.lower_spotify do
        play_file "yeah.mp3"
      end
    when "hähä"
      Spotify.lower_spotify do
        play_file "hehe.mp3"
      end
    when "airwolf"
      Spotify.lower_spotify do
        play_file "airwolf.m4a"
      end
    when "ateam"
      Spotify.lower_spotify do
        play_file "a_team.m4a"
      end
    when "applause"
      Spotify.lower_spotify do
        play_file "applause.mp3"
      end
    when "giggle"
      Spotify.lower_spotify do
        play_file "giggle.mp3"
      end
    when "bomb"
      Spotify.lower_spotify do
        play_file "bomb.mp3"
      end
    when "suprise"
      Spotify.lower_spotify do
        play_file "suprise.m4r"
      end
    when "hoho"
      Spotify.lower_spotify do
        play_file "hoho.mp3"
      end
    when "haha"
      Spotify.lower_spotify do
        play_file "haha.wav"
      end
    when "snore"
      Spotify.lower_spotify do
        play_file "snore.wav"
      end
    when "muhaha"
      Spotify.lower_spotify do
        play_file "muhaha.mp3"
      end
    when "godwillsit"
      Spotify.lower_spotify do
        play_file "godwillsit.m4a"
      end
    when "sting"
      Spotify.lower_spotify do
        play_file "string.m4a"
      end
    end
  end

  private

  def self.play_file(file_name)
    system "afplay", File.expand_path(File.join(__FILE__, "..", "..", "..", "extras", file_name))
  end
end
