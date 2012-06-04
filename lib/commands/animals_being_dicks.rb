require 'typhoeus'
require 'nokogiri'
class AnimalsBeingDicks < Flower::Command
  respond_to "dicks", "animals", "abd"
  URL = "http://animalsbeingdicks.com/random"

  def self.description
    "Post a random animals being dicks gif"
  end

  def self.respond(command, message, sender, flower)
    flower.say(image)
  end

  def self.image
    document = Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
    document.at_css(".post img").attribute('src').value
  end
end