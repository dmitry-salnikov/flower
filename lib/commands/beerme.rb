require 'typhoeus'
require 'nokogiri'
class Beerme < Flower::Command
  respond_to 'beerme'
  URL = 'http://www.strangebrew.ca/beername.php?Mode=Generate'
  def self.description
    'Beer me randomly'
  end

  def self.respond(message)
    message.say(text)
  end

  def self.text
    document = Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
    beer = document.search('b').first.content
    "Have a tall: #{beer}"
  end
end