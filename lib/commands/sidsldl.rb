# encoding: utf-8
class Sidsldl < Flower::Command
  listen_to /(david.*varför|varför.*david).*\?/i
  listen_to /kbk/i

  def self.description
    "Skit i det så lever du längre"
  end

  def self.listen(message, sender, flower)
    if message =~ /kbk/i
      flower.say("KÖR BARA KÖR!")
    else
      flower.say("#{sender[:nick]}, skit i det så lever du längre!", :mention => sender[:id])
    end
  end
end
