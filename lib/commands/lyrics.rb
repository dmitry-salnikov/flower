require 'open-uri'
require 'nokogiri'

class Lyrics < Flower::Command
  respond_to "lyrics"

  URL = "http://search.letssingit.com/cgi-exe/am.cgi?a=search&l=archive&s=<q>"

  def self.respond(message)
    current_track = message.argument.present? ? message.argument : get_current_song
    if lyrics = find_lyrics(current_track)
      message.paste(lyrics)
    else
      message.say("Could not find song lyrics. :(")
    end
  end

  def self.find_lyrics(query)
    document = Nokogiri.HTML(open(URL.gsub("<q>", URI.escape(query))))
    lyrics_href = document.at_css(".data_list td:nth(3) a").attribute("href").value
    document = Nokogiri.HTML(open(lyrics_href))
    document.at_css("div#lyrics").inner_html.gsub("<br><br>", "\n").gsub("<br>", "").split("\n")
  rescue
    false
  end

  def self.get_current_song
    Spotbot.current_track
  end
end
