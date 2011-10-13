require 'pry'
class Flower::Session
  attr_accessor :login_url, :email, :password, :cookie, :flower

  def initialize(flower)
    self.login_url = "https://www.flowdock.com/session"
    self.email     = Flower::Config.email
    self.password  = Flower::Config.password
    self.flower = flower
  end

  def login
    require 'em-http'
    post_data = {:user_session => {:email => email, :password => password}}
    EM::HttpRequest.new(login_url).post(:head => {'Content-Type' => 'application/x-www-form-urlencoded'}, :body => post_data).callback do |http|
      # TODO: handle code != 302
      @cookie = http.response_header["SET_COOKIE"].join("; ")
      handshake
    end
  end

  def handshake
    EM::HttpRequest.new("https://mynewsdesk.flowdock.com/flows/#{Flower::Config.flow}.json").get(:head => {'cookie' => @cookie}).callback { |http|
      join
    }
  end

  def join
    EM::HttpRequest.new("https://mynewsdesk.flowdock.com/messages").post(
      :keepalive => true,
      :head => {
        'cookie' => @cookie,
        'Content-Type' => 'application/x-www-form-urlencoded'
      },
      :body => {
        :channel => '/meta',
        :event => 'join',
        :message => "{\"channel\":\"/flows/#{Flower::Config.flow}\",\"client\":\"jnfEIHE23ff\"}"
      }
    ).callback { |http|
      subscribe
    }
  end

  def subscribe
    start_time = (Time.now.to_f*1000).to_i
    parser = Yajl::Parser.new(:symbolize_keys => true)

    parser.on_parse_complete = proc do |data|
      flower.respond_to data if data[:event] == "message" && data[:sent] > start_time
    end
    puts "subscribe!"
    http = EM::HttpRequest.new("https://mynewsdesk.flowdock.com/messages").get(
      :query => {:ack => -1,:mode => 'stream2',:last_activity => Time.now.to_i,:client => "jnfEIHE23ff"},
      :keepalive => true,
      :head => {'cookie' => @cookie,'Content-Type' => 'application/x-www-form-urlencoded'}
    )
    
    http.stream do |chunk|
      begin
        parser << chunk;
      rescue Yajl::ParseError
        puts "yajl error"
      end
    end
    http.errback do
      puts "error connection"
      subscribe
    end
  end


  def post(message, tags)
    puts "posting!!!!!"
    data = {}
    data["message"] = "\"#{message}\""
    data["app"] = "chat"
    data["event"] = "message"
    data["tags"] = (tags || []).join(" ")
    data["channel"] = "/flows/#{Flower::Config.flow}"
    EM::HttpRequest.new("https://mynewsdesk.flowdock.com/messages").post(:head => {
        'cookie' => @cookie,
        'Content-Type' => 'application/x-www-form-urlencoded'
      },
      :body => data).callback{ |http|
        puts http.response
      }
  end
end
