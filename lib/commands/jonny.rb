require 'nokogiri'
class Jonny < Flower::Command
  respond_to "jonny", "tfd", "javve"
  listen_to /.* (jonny|tfd|javve)(\s|$|\.).*/i
  URL = "http://thatswhatjonnysaid.com/random"

  def self.description
    "Post a random jony quote"
  end

  def self.listen(message)
    message.say("#{quote} #thatswhatjonnysaid", :mention => message.user_id)
  end

  def self.respond(message)
    message.say("#{quote} #thatswhatjonnysaid")
  end

  def self.quote
    document = Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
    document.at_css(".thequote").text
  end
end
