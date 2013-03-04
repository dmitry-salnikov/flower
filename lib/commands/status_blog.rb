require 'tumblr_client'
class StatusBlog < Flower::Command
  Tumblr.configure do |config|
    config.consumer_key = Flower::Config.tumblr_consumer_key
    config.consumer_secret = Flower::Config.tumblr_consumer_secret
    config.oauth_token = Flower::Config.tumblr_oauth_token
    config.oauth_token_secret = Flower::Config.tumblr_oauth_token_secret
  end

  URL = Flower::Config.tumblr_url

  respond_to "status", "tumblr"

  def self.respond(command, message, sender, flower)
    if message.present?
      type, status = message.split(" ", 2)
      type.downcase!
      if ["ok", "problem", "maintenance"].include? type
        post(type, status, flower)
      else
        flower.say "begin message with a status type (ok, problem, maintenance)"
      end
    else
      post = client.posts(URL, limit: 1)['posts'].first
      flower.paste(["##{post['tags'].first} #{post['body'].gsub(/<\/?[^>]*>/, "")}"])
    end
  end

  def self.post(type, status, flower)
    response = client.text(URL, body: status, tags: [type])
    flower.say "#{type} posted: #{status} - http://#{URL}/post/#{response['id']}"
  end

  def self.client
    @client ||= Tumblr::Client.new
  end
end
