# encoding: utf-8
class Say < Flower::Command
  respond_to "say", "whisper", "sing", "säg"

  def self.respond(message)
    case message.command
    when "whisper"
      system "say", "-vwhisper", message.argument
    when "sing"
      system "say", "-vcello", message.argument
    when "say"
      system "say", message.argument
    when "säg"
      voices = %w(Oskar Alva)
      system "say", "-v#{voices.sample}", message.argument
    end
  end

  def self.description
    "Say it with words"
  end
end
