class Flower::Message
  attr_reader :data, :output
  attr_accessor :sender, :flower, :rest, :internal

  def initialize(data)
    @data = data
  end

  def flow
    @flow ||= data[:flow].split(":").last
  end

  def content
    @content ||= data[:content]
  end

  def command
    if msg = bot_message
      msg[1].split(" ").first
    end
  end

  def argument
    @argument ||= message.split(" ", 2)[1]
  end

  def argument=(argument)
    @argument = argument
  end

  def event
    @event ||= data[:event]
  end

  def respond?
    event =~ /message|comment/ && Flower::Config.flows.include?(flow)
  end

  def from_self?
    sender[:nick] == Flower::Config.bot_nick
  end

  def user_id
    @user ||= data[:user].to_i
  end

  def bot_message
    message.respond_to?(:match) && message.match(/^(?:!)[\s|,|:]*(.*)/i)
  end

  def bot_message?
    !!bot_message
  end

  # Actual message can be in:
  # - key :content
  # - nested key :content/:text
  # - nested key :content/:updated_content
  # - nested key :content/:updated_content/:text
  def message
    @message ||= begin
      if content
        if content.is_a?(Hash)
          if content[:updated_content].is_a?(Hash)
            content[:updated_content][:text]
          else
            content[:text] || content[:updated_content]
          end
        else
          content
        end
      else
        ""
      end
    end
  end

  def message=(message)
    @message = message
  end

  def messages
    messages = message.split("|")
    if messages.size > 1
      messages.map do |sub_message|
        new_message = self.dup
        new_message.message = sub_message
        new_message
      end
    else
      [self]
    end
  end

  def say(reply, options = {})
    reply = reply.respond_to?(:join) ? reply.join("\n") : reply
    @output = reply
    rest.post_message(reply, parse_tags(options), flow)
  end

  def paste(reply, options = {})
    reply = reply.join("\n") if reply.respond_to?(:join)
    reply = reply.split("\n").map{ |str| (" " * 4) + str }.join("\n")
    reply = reply.respond_to?(:join) ? reply.join("\n") : reply
    @output = reply
    rest.post_message(reply, parse_tags(options), flow)
  end

  def parse_tags(options)
    if options[:mention]
      [":highlight:#{options[:mention]}"]
    end
  end
end