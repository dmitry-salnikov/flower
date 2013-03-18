require 'typhoeus'
require 'nokogiri'
class MissedHighfive < Flower::Command
  respond_to "mhf", "missed", "missedhighfive"
  URL = "http://missedhighfive.tumblr.com/random"

  def self.description
    "Post a random missed highfive gif"
  end

  def self.respond(message)
    mhf = case message.argument
          when 'epic'
            "http://www.xiaohaiblog.com/wp-content/uploads/2012/10/original.gif"
          else
            image
          end

    message.say(mhf)
  end

  def self.image
    document = Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
    if img = document.at_css(".post img")
      img.attribute('src').value
    else
      image
    end
  end
end
