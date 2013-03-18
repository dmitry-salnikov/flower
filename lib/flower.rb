require "rubygems"
require "bundler/setup"
require 'json'
require 'eventmachine'
require 'em-http'
require 'yajl'

class Flower
  require File.expand_path(File.join(File.dirname(__FILE__), 'message'))
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

  attr_accessor :stream, :rest, :users, :pid

  def initialize
    self.pid      = Process.pid
    self.stream   = Stream.new(self)
    self.rest     = Rest.new
    self.users    = {}
  end

  def boot!
    EM.run {
      get_users rest.get_users
      stream.start
      EventMachine::start_server("localhost", Flower::Config.em_port, LocalServer) { |s| s.set_flower(self) }
    }
  end

  def respond_to(message)
    Thread.new do
      message.sender = users[message.user_id]
      message.flower = self
      message.rest = rest
      Thread.exit if !message.sender # Don't break when the mnd CLI tool is posting to chat
      message.messages.each do |sub_message|
        if sub_message.bot_message?
          Flower::Command.delegate_command(sub_message)
        end
        unless message.from_self? || message.internal
          Flower::Command.trigger_listeners(message)
          Flower::Command.register_stats(message)
        end
      end
    end
  end

  def get_users(users_json)
    users_json.each do |user|
      self.users[user["id"]] = {:id => user["id"], :nick => user["nick"]}
    end
  end
end
