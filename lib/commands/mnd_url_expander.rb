require 'httparty'
class MndUrlExpander < Flower::Command
  respond_to "expand", "eurl", "esurl"

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
      @surl = nil
      puts "#{error.inspect}:\n#{error.backtrace.join("\n")}"
    end
  end

  private

  def self.surl(message = nil)
    @surl ||= make_request(message)
  end

  def self.make_request(message)
    HTTParty.get('http://mnd.to/' + message.split('/').last,
      :headers => { 'Accept' => 'application/json' },
      :query   => { :key => Flower::Config.mnd_to_key }
    ).parsed_response
  end

  def self.error_messages
    surl["errors"].keys.map { |key| "#{key}: " + surl["errors"][key].join(", ") }.join("\n")
  end
end
