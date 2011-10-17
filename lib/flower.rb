require "rubygems"
require "bundler/setup"
require 'json'
require 'eventmachine'
require 'em-http'
require 'yajl'

class Flower
  require File.expand_path(File.join(File.dirname(__FILE__), 'session'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'command'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'config'))

  COMMANDS = {} # We are going to load available commands in here

  Dir.glob("lib/commands/**/*.rb").each do |file|
    require File.expand_path(File.join(File.dirname(__FILE__), "..", file))
  end

  attr_accessor :messages_url, :post_url, :flow_url, :session, :users, :pid, :nick

  def initialize
    # self.messages_url = base_url + "/flows/#{Flower::Config.flow}/apps/chat/messages"
    # self.post_url     = base_url + "/messages"
    # self.flow_url     = base_url + "/flows/#{Flower::Config.flow}.json"
    self.nick         = Flower::Config.bot_nick
    self.pid          = Process.pid
    self.session      = Session.new(self)
    self.users        = {}
  end

  def boot!
    EM.run {
    session.login
    }
  end

  def paste(message, options = {})
    message = message.join("\n") if message.respond_to?(:join)
    message = message.split("\n").map{ |str| (" " * 4) + str }.join("\\n")
    post(message, parse_tags(options))
  end

  def say(message, options = {})
    post(message, parse_tags(options))
  end

  def respond_to(message_json)
      if match = bot_message(message_json[:content])
        match = match.to_a[1].split
        Flower::Command.delegate_command(match.shift || "", match.join(" "), users[message_json[:user].to_i], self)
      end
  end

  def get_users(users_json)
    users_json.map{|u| u["user"] }.each do |user|
      self.users[user["id"]] = {:id => user["id"], :nick => user["nick"]}
    end
  end

  def greet_users
    say("I'm now online and responding to \\\"#{nick}\\\"! My pid is #{pid}.")
  end

  private
  # def base_url
  #   "https://#{Flower::Config.company.downcase}.flowdock.com"
  # end

  def bot_message(content)
    content.respond_to?(:match) && content.match(/^(?:bot|!)[\s|,|:]*(.*)/i)
  end

  def post(message, tags = nil)
    session.post(message, tags)
  end

  def parse_tags(options)
    if options[:mention]
      [":highlight:#{options[:mention]}"]
    end
  end
end
