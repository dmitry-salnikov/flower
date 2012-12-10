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
  require File.expand_path(File.join(File.dirname(__FILE__), 'server'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'stats'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'em_client'))

  COMMANDS = {} # We are going to load available commands in here
  LISTENERS = {} # We are going to load available monitors in here

  Dir.glob("lib/commands/**/*.rb").each do |file|
    require File.expand_path(File.join(File.dirname(__FILE__), "..", file))
  end

  attr_accessor :messages_url, :post_url, :flow_url, :stream, :rest, :users, :pid, :nick, :message, :tags

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
      EventMachine::start_server("10.44.35.147", Flower::Config.em_port, Server)
      EM.run {
        EventMachine.connect("10.44.35.147", Flower::Config.em_port, EmClient)
      }
    }
  end

  def paste(message, options = {})
    message = message.join("\n") if message.respond_to?(:join)
    message = message.split("\n").map{ |str| (" " * 4) + str }.join("\n")
    self.message = message.respond_to?(:join) ? message.join("\n") : message
    self.tags = parse_tags(options)
  end

  def say(message, options = {})
    self.message = message.respond_to?(:join) ? message.join("\n") : message
    self.tags = parse_tags(options)
  end

  def respond_to(message_json)
    Thread.new do
      self.message = nil
      sender = users[message_json[:user].to_i]
      Thread.exit if !sender # Don't break when the mnd CLI tool is posting to chat
      extract_content(message_json[:content]).split("|").each do |content|
        if self.message
          content = "#{content} #{self.message}"
          self.message = nil
        end
        if match = bot_message(content)
          match = match.to_a[1].split
          command = (match.shift || "").downcase
          Flower::Command.delegate_command(command, match.join(" "), sender, self)
        end
        unless message_json[:internal] || from_self?(sender)
          Flower::Command.trigger_listeners(content, sender, self)
          Flower::Command.register_stats(command, sender)
        end
      end
      post(self.message, self.tags)
    end
  end

  def get_users(users_json)
    users_json.each do |user|
      self.users[user["id"]] = {:id => user["id"], :nick => user["nick"]}
    end
  end

  private

  def from_self?(sender)
    sender[:nick] == nick
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

  def extract_content(message)
    message.is_a?(Hash) ? message[:text] : message
  end
end
