require 'httparty'
class MndUrlShortener < Flower::Command
  respond_to "shorten", "surl"

  def self.description
    "Shorten a URL with mnd.to, pass a second param for custom name"
  end

  def self.respond(command, message, sender, flower)
    begin
      if surl(message)['status']
        flower.say(surl['url']['short'], :mention => sender[:id])
      else
        flower.say("It didn't work.\n" + error_messages, :mention => sender[:id])
      end
      @surl = nil
    rescue => error
      @surl = nil
      puts "#{error.inspect}:\n#{error.backtrace.join("\n")}"
    end
  end

  private

  def self.surl(message = nil)
    @surl ||= make_request(message)
  end

  def self.make_request(message)
    original, short = message.split(' ').map { |str| str.strip }

    body            = {}
    body[:key]      = Flower::Config.mnd_to_key
    body[:original] = original
    body[:short]    = short if !short.nil? && short.length > 0

    HTTParty.post('http://mnd.to/',
      :headers => { 'Accept' => 'application/json' },
      :body    => body
    ).parsed_response
  end

  def self.error_messages
    surl["errors"].keys.map { |key| "#{key}: " + surl["errors"][key].join(", ") }.join("\n")
  end
end
