# encoding: utf-8
class Sidsldl < Flower::Command
  listen_to /varför.*\?/i
  
  def self.description
    "Skit i det så lever du längre"
  end

  def self.listen(message, sender, flower)
    flower.say("#{sender[:nick]}, skit i det så lever du längre!", :mention => sender[:id])
  end
end