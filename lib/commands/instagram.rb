require 'instagram'

class InstagramCommand < Flower::Command
  Instagram.configure do |config|
    config.client_id = Flower::Config.instagram_id
    config.client_secret = Flower::Config.instagram_secret
  end

  respond_to "insta", "instagram"

  def self.respond(message)
    if message.argument
      search = URI.escape(message.argument.split(" ").first)
      if image = image_path(search)
        message.say(image)
      else
        message.say("No hits :(")
      end
    else
      message.say("(Enter search term)")
    end
  end

  def self.image_path(query)
    result = Instagram.tag_recent_media(query) rescue nil
    if result && data = result.data.to_a.try(:sample)
      data.images.standard_resolution.url
    end
  end
end
