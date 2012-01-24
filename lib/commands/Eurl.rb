require 'httparty'
class Eurl < Flower::Command
  respond_to "expand", "eurl"

  def self.description
    "Expand a URL shortened with mnd.to"
  end

  def self.respond(command, message, sender, flower)
    begin
      if surl(message)['status']
        flower.say("#{surl['url']['original']} (redirects: #{surl['url']['redirects']}, lookups: #{surl['url']['lookups']})", :mention => sender[:id])
      else
        flower.say("Didn't work: #{error_messages}", :mention => sender[:id])
      end
      @surl = nil
    rescue => error
      puts "#{error.inspect}:\n#{error.backtrace.join("\n")}"
    end
  end

  private
  def self.api_key
    '7d54c7f0ee68f12391bc9ca7f8d4dc3c1fe2ee812e5c2edfcf908f9a812ccdee'
  end

  def self.surl(message = nil)
    @surl ||= HTTParty.get('http://mnd.to/api/v1/' + message.split('/').last, :query => { :api_key => api_key }).parsed_response
  end

  def self.error_messages
    surl["errors"].keys.map { |key| "#{key}: " + surl["errors"][key].join(", ") }.join("\n")
  end
end
