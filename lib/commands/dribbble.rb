class Dribbble < Flower::Command
  respond_to "dribbble"
  require 'typhoeus'

  IMAGE_CACHE = {}

  def self.description
    "Post random dribbble image (!dribbble [username])"
  end

  def self.respond(command, message, sender, flower)
    if message != ""
        flower.say(image_from_user(message))
    else
        flower.say(image)
    end
  end

  def self.image
    url = "http://api.dribbble.com/shots/#{rand(722835)}"
    response = Typhoeus::Request.get(url)
    if (response.code == 404)
        self.image
    else
        JSON.parse(response.body)["image_url"]
    end
  end

  def self.image_from_user(user)
    url = "http://api.dribbble.com/players/#{user}/shots"
    response = Typhoeus::Request.get(url)
    if (response.code == 404)
        "User not found, try Javve :)"
    else
        JSON.parse(response.body)['shots'].sample['image_url']
    end
  end
end