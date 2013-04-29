class DevOps < Flower::Command
  respond_to "devops", "ops"
  URL = "http://devopsreactions.tumblr.com/random"

  def self.description
    "Post a random DevOps reactions gif"
  end

  def self.respond(message)
    message.say("#{image}\n#{title}")
  end

  private

  def self.title
    document.at_css('title').text.split("- DevOps").first.strip
  end

  def self.image
    document.at_css("p img").attribute('src').value
  end

  def self.document
    Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
  end
end
