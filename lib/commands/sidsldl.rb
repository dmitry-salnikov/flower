# encoding: utf-8
class Sidsldl < Flower::Command
  listen_to /(david.*varför|varför.*david).*\?/i
  listen_to /kbk/i

  def self.description
    "Skit i det så lever du längre"
  end

  def self.listen(message)
    if message.message =~ /kbk/i
      message.say("KÖR BARA KÖR! :shipit:")
    else
      message.say("#{sender[:nick]}, skit i det så lever du längre!", :mention => sender[:id])
    end
  end
end
