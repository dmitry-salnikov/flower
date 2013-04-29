class DevOps < Flower::Command
  respond_to "devops", "ops"
  URL = "http://devopsreactions.tumblr.com/random"

  def self.description
    "Post a random DevOps reactions gif"
  end

  def self.respond(message)
    post = document
    message.say("#{image(post)}\n#{title(post)}")
  end

  private

  def self.title(post)
    post.at_css('title').text.split("- DevOps").first.strip
  end

  def self.image(post)
    post.at_css("p img").attribute('src').value
  end

  def self.document
    Nokogiri.HTML(Typhoeus::Request.get(URL, :follow_location => true).body)
  end
end
