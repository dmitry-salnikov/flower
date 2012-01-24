class Surl < Flower::Command
  respond_to "shorten", "surl"

  def self.description
    "Shorten a URL with mnd.to"
  end

  def self.respond(command, message, sender, flower)
    if surl(message)['status']
      flower.say(surl['url']['short'], :mention => sender[:id])
    else
      flower.say("It didn't work.\n" + error_messages, :mention => sender[:id])
    end
  end

  private
  def self.api_key
    '7d54c7f0ee68f12391bc9ca7f8d4dc3c1fe2ee812e5c2edfcf908f9a812ccdee'
  end

  def surl(message = nil)
    @surl ||= HTTParty.post('http://mnd.to/api/v1/', :query => { :url => message, :api_key => api_key).parsed_response
  end

  def error_messages
    surl["errors"].keys.map { |key| "#{key}: " + surl["errors"][key].join(", ") }.join("\n")
  end
end
