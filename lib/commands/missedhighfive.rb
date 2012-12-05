require 'typhoeus'
require 'nokogiri'
class MissedHighfive < Flower::Command
  respond_to "mhf", "missed", "missedhighfive"
  URL = "http://missedhighfive.tumblr.com/random"

  def self.description
    "Post a random missed hight five gif"
  end

  def self.respond(command, message, sender, flower)
    flower.say(image)
  end

  def self.image
    document = Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
    document.at_css(".post img").attribute('src').value
  end
end