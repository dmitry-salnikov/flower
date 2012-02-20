# encoding: UTF-8
class SoundFx < Flower::Command
  respond_to "easy", "sax", "friday", "rimshot", "sad", "yeah", "hähä", "airwolf", "ateam"

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
        play_file "airwolf.mp3"
      end
    when "ateam"
      Spotify.lower_spotify do
        play_file "a_team.mp3"
      end
    end
  end

  private

  def self.play_file(file_name)
    system "afplay", File.expand_path(File.join(__FILE__, "..", "..", "..", "extras", file_name))
  end
end
