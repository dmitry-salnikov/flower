require 'open-uri'
require 'nokogiri'

class Lyrics < Flower::Command
  respond_to "lyrics"

  URL = "http://search.letssingit.com/cgi-exe/am.cgi?a=search&l=archive&s=<q>"

  def self.respond(command, message, sender, flower)
    message = get_current_song unless message.present?
    if lyrics = find_lyrics(message)
      flower.paste(lyrics)
    else
      flower.say("Could not find song lyrics. :(")
    end
  end

  def self.find_lyrics(query)
    document = Nokogiri.HTML(open(URL.gsub("<q>", URI.escape(query))))
    lyrics_href = document.at_css(".data_list td:nth(3) a").attribute("href").value
    document = Nokogiri.HTML(open(lyrics_href))
    document.at_css("div#lyrics").inner_html.gsub("<br>", "").split("\n")
  rescue
    false
  end

  def self.get_current_song
    if SpotifyCommand.hallon_track
      "#{SpotifyCommand.hallon_track.artist} #{SpotifyCommand.hallon_track.name}"
    elsif SpotifyCommand.spotify.current_track
      "#{SpotifyCommand.spotify.current_track.artist.get} #{SpotifyCommand.spotify.current_track.name.get}"
    end
  end
end
