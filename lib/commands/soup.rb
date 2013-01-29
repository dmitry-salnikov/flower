require 'typhoeus'
require 'nokogiri'
require 'time'

class Soup < Flower::Command
  respond_to "soup", "soppa"
  URL = "http://iloapp.olandskan.se/blog/dagens?category=0"
  WDAY = Time.now.wday

  def self.description
    "Get soup menu for the week"
  end

  def self.respond(command, message, sender, flower)
    if message == "today" || message == "dagens"
      flower.paste(todays_menu)
    else
      flower.paste(menu)
    end
  end

  def self.menu
    document = Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
    document.at_css("#mainDiv > .post").css("p").map(&:text)[1..-1].join("\n")
  end

  def self.todays_menu
    document = Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
    document.at_css("#mainDiv > .post").css("p").map(&:text)[1..-1][WDAY..WDAY + 1].join("\n")
  end
end
