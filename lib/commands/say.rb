# encoding: utf-8
class Say < Flower::Command
  respond_to "say", "whisper", "sing", "säg"

  def self.respond(command, message, sender, flower)
    case command
    when "whisper"
      system "say", "-vwhisper", message
    when "sing"
      system "say", "-vcello", message
    when "say"
      system "say", message
    when "säg"
      voices = %w(Oskar Alva)
      system "say", "-v#{voices.sample}", message
    end
  end

  def self.description
    "Say it with words"
  end
end
