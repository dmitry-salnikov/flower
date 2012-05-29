# encoding: UTF-8
class SoundCommand < Flower::Command

  private

  def self.play_file(file_name, lower_spotify = true)
    if lower_spotify
      Spotify.lower_spotify do
        system "afplay", File.expand_path(File.join(__FILE__, "..", "..", "..", "extras", file_name))
      end
    else
      system "afplay", File.expand_path(File.join(__FILE__, "..", "..", "..", "extras", file_name))
    end
  end
end
