require "rubygems"
require "bundler/setup"
require 'json'
require 'eventmachine'
require 'em-http'
require 'yajl'

class Flower
  require File.expand_path(File.join(File.dirname(__FILE__), 'stream'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'rest'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'command'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'config'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'local_server'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'stats'))

  COMMANDS = {} # We are going to load available commands in here
  LISTENERS = {} # We are going to load available monitors in here

  Dir.glob("lib/commands/**/*.rb").each do |file|
    require File.expand_path(File.join(File.dirname(__FILE__), "..", file))
  end

  attr_accessor :messages_url, :post_url, :flow_url, :stream, :rest, :users, :pid, :nick

  def initialize
    self.nick     = Flower::Config.bot_nick
    self.pid      = Process.pid
    self.stream   = Stream.new(self)
    self.rest     = Rest.new
    self.users    = {}
  end

  def boot!
    EM.run {
      get_users rest.get_users
      stream.start
      EventMachine::start_server("localhost", 6000, LocalServer) { |s| s.set_flower(self) }
    }
  end

  def paste(message, options = {})
    message = message.join("\n") if message.respond_to?(:join)
    message = message.split("\n").map{ |str| (" " * 4) + str }.join("\n")
    post(message, parse_tags(options))
  end

  def say(message, options = {})
    message = message.join("\n") if message.respond_to?(:join)
    post(message, parse_tags(options))
  end

  def respond_to(message_json)
    if match = bot_message(message_json[:content])
      match = match.to_a[1].split
      command = match.shift || ""
      Flower::Command.delegate_command(command.downcase, match.join(" "), users[message_json[:user].to_i], self)
    end
    Flower::Command.trigger_listeners(message_json[:content], users[message_json[:user].to_i], self) unless message_json[:internal] || from_self?(message_json)
  end

  def get_users(users_json)
    users_json.each do |user|
      self.users[user["id"]] = {:id => user["id"], :nick => user["nick"]}
    end
  end

  private

  def from_self?(message_json)
    users[message_json[:user].to_i][:nick] == nick
  end

  def bot_message(content)
    self.class.bot_message(content)
  end

  def self.bot_message(content)
    content.respond_to?(:match) && content.match(/^(?:!)[\s|,|:]*(.*)/i)
  end

  def post(message, tags = nil)
    rest.post_message(message, tags)
  end

  def parse_tags(options)
    if options[:mention]
      [":highlight:#{options[:mention]}"]
    end
  end
end
