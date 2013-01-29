require 'typhoeus'
require 'nokogiri'
class Soup < Flower::Command
  respond_to "soup"
  URL = "http://iloapp.olandskan.se/blog/dagens?category=0"

  def self.description
    "Get soup menu for the week"
  end

  def self.respond(command, message, sender, flower)
    flower.paste(menu)
  end

  def self.menu
    document = Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
    document.at_css("#mainDiv > .post").css("p").map(&:text)[1..-1].join("\n")
  end
end
