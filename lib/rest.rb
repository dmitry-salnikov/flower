require 'typhoeus'
class Flower::Rest
  def post_message(message, tags = [])
    message = {
      content: message,
      tags: tags || [],
      event: 'message'
    }

    Typhoeus::Request.post(post_url, {params: message})
  end

  def get_users
    response = Typhoeus::Request.get(flow_url)
    JSON.parse(response.body)["users"]
  end

  private

  def flow_url
    "https://#{Flower::Config.api_token}@api.flowdock.com/flows/#{Flower::Config.company}/#{Flower::Config.flow}"
  end

  def post_url
    "#{flow_url}/messages"
  end
end