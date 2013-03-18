require 'typhoeus'
class Flower::Rest
  def post_message(message, tags = [], flow)
    message = {
      content: message,
      tags: tags || [],
      event: 'message'
    }

    r = Typhoeus::Request.post(post_url(flow), {params: message})
  end

  def get_users
    response = Typhoeus::Request.get(flow_url)
    JSON.parse(response.body)["users"]
  end

  private

  def flow_url(flow = Flower::Config.flows.first)
    "https://#{Flower::Config.api_token}@api.flowdock.com/flows/#{Flower::Config.company}/#{flow}"
  end

  def post_url(flow)
    "#{flow_url(flow)}/messages"
  end
end