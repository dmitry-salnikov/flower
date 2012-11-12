require 'instagram'

class InstagramCommand < Flower::Command
  Instagram.configure do |config|
    config.client_id = Flower::Config.instagram_id
    config.client_secret = Flower::Config.instagram_secret
  end

  respond_to "insta", "instagram"

  def self.respond(command, message, sender, flower)
    flower.say(image_path(message)) if message.present?
  end

  def self.image_path(query)
    result = Instagram.tag_recent_media(query)
    if data = result.data.to_a.try(:sample)
      data.images.standard_resolution.url
    end
  end
end
