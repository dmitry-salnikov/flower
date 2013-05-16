require 'typhoeus'
require 'nokogiri'
class Soup < Flower::Command
  respond_to "soup", "soppa"
  URL = "http://iloapp.olandskan.se/blog/dagens?category=0"

  def self.description
    "Get soup menu for the week"
  end

  def self.respond(message)
    message.paste(menu)
  end

  def self.menu
    return "Ärtsoppa, stupid!" if Time.now.wday == 4
    document = Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
    document.at_css("#mainDiv > .post").css("p").map(&:text)[1..-1].join("\n")
  end
end
