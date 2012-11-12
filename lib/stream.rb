require "em-eventsource"
class Flower::Stream
  attr_accessor :flower, :api_token, :stream

  def initialize(flower)
    self.api_token = Flower::Config.api_token
    self.flower    = flower
  end

  def start
    source = EventMachine::EventSource.new(stream_url, nil, request_headers)
    source.message do |message|
      parser << message
    end

    source.open do
      puts "** Stream open"
    end

    source.error do |error|
      puts "** error #{error}"
    end

    source.start
  end

  private

  def parser
    return @parser unless @parser.nil?
    @parser = Yajl::Parser.new(:symbolize_keys => true)
    @parser.on_parse_complete = proc do |data|
      flower.respond_to data if data[:event] =~ /message|comment/ && data[:flow] == "#{Flower::Config.company}:#{Flower::Config.flow}"
    end
    @parser
  end

  def request_headers
    auth = Base64.encode64(api_token).strip << '='
    {:accept => 'text/event-stream', 'Authorization' => "Basic #{auth}"}
  end

  def stream_url
    "https://stream.flowdock.com/flows/#{Flower::Config.company}/#{Flower::Config.flow}"
  end
end