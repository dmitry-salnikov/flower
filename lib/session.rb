require 'eventmachine'
require 'em-http'
class Flower::Session
  attr_accessor :login_url, :email, :password, :cookie, :flower, :client_id

  LOGIN_URL = "https://www.flowdock.com/session"
  def initialize(flower)
    self.email     = Flower::Config.email
    self.password  = Flower::Config.password
    self.flower = flower
    self.client_id = rand(36**16).to_s(36)
  end

  def login
    require 'em-http'
    post_data = {:user_session => {:email => email, :password => password}}
    http = EM::HttpRequest.new(LOGIN_URL).post(
      :head => {'Content-Type' => 'application/x-www-form-urlencoded'},
      :body => post_data
    )
    http.callback do |http|
      if http.response_header.status == 302
        @cookie = http.response_header.cookie
        handshake
      else
        raise "Error on connect..."
      end
    end
  end

  def handshake
    http = EM::HttpRequest.new("https://mynewsdesk.flowdock.com/flows/#{Flower::Config.flow}.json").get(:head => {'cookie' => @cookie})
    http.callback do |http|
      flower.get_users(JSON.parse(http.response)["users"])
      join
    end
  end

  def join
    post_data = {:channel => "/meta", :event => "join", :message => "{\"channel\":\"/flows/#{Flower::Config.flow}\",\"client\":\"#{client_id}\"}"}
    http = EM::HttpRequest.new("https://mynewsdesk.flowdock.com/messages").post(
      :head => {
        'cookie' => @cookie,
        'Content-Type' => 'application/x-www-form-urlencoded'
      },
      :body => post_data
    )
    http.callback do |http|
      flower.greet_users
      subscribe
    end
  end

  def subscribe
    start_time = (Time.now.to_f*1000).to_i
    parser = Yajl::Parser.new(:symbolize_keys => true)

    parser.on_parse_complete = proc do |data|
      flower.respond_to data if data[:event] == "message" && data[:sent] > start_time && data[:flow] == Flower::Config.flow
    end
    http = EM::HttpRequest.new("https://mynewsdesk.flowdock.com/messages").get(
      :query => {:ack => -1,:mode => 'stream2',:last_activity => Time.now.to_i,:client => client_id},
      :keepalive => true,
      :head => {'cookie' => @cookie,'Content-Type' => 'application/x-www-form-urlencoded'}
    )

    http.callback do |http|
      join
    end
    
    http.stream do |chunk|
      begin
        parser << chunk;
      rescue Yajl::ParseError
      end
    end
    http.errback do
      subscribe # reconnecting
    end
  end


  def post(message, tags)
    post_data = {:message => "\"#{message}\"", :app => "chat", :event => "message", :tags => (tags || []).join(" "), :channel => "/flows/#{Flower::Config.flow}"}
    EM::HttpRequest.new("https://mynewsdesk.flowdock.com/messages").post(:head => {'cookie' => @cookie,'Content-Type' => 'application/x-www-form-urlencoded'},
      :body => post_data)
  end
end
