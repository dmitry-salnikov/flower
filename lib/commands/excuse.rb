require 'typhoeus'
require 'nokogiri'
class Excuse < Flower::Command
  respond_to "excuse", "developerexcuse"
  URL = "http://developerexcuses.com/"

  def self.description
    "Post a developer excuse"
  end

  def self.respond(message)
    message.say(text)
  end

  def self.text
    document = Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
    document.at_css(".wrapper center").content
  end
end