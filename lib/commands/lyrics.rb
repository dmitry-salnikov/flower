require 'open-uri'
require 'nokogiri'

class Lyrics < Flower::Command
  respond_to "lyrics"

  URL = "http://search.letssingit.com/cgi-exe/am.cgi?a=search&l=archive&s=<q>"

  def self.respond(command, message, sender, flower)
    lyrics = find_lyrics(message)
    flower.paste(lyrics)
  end

  def self.find_lyrics(query)
    document = Nokogiri.HTML(open(URL.gsub("<q>", URI.escape(query))))
    lyrics_href = document.at_css(".data_list td:nth(3) a").attribute("href").value
    document = Nokogiri.HTML(open(lyrics_href))
    document.at_css("div#lyrics").inner_html.gsub("<br>", "").split("\n")
  end
end
