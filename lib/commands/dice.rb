class Dice < Flower::Command
  respond_to "dice"

  DICES = %w(
    http://www.random.org/dice/dice1.png
    http://www.random.org/dice/dice2.png
    http://www.random.org/dice/dice3.png
    http://www.random.org/dice/dice4.png
    http://www.random.org/dice/dice5.png
    http://www.random.org/dice/dice6.png
  )

  DEFAULT_COUNT = 1
  MAX_COUNT = 6
  MAX_DICE = 6

  def self.description
    "Let's play dice!"
  end

  def self.respond(message)
    count = DEFAULT_COUNT
    count = message.argument.to_i if message.argument =~ /^\d+/
    count = DEFAULT_COUNT if count > MAX_COUNT || count <= 0
    total = 0
    results = count.times.map do
      id = Random.rand(MAX_DICE)
      total = total + id + 1
      DICES[id]
    end
    results << "#{message.sender[:nick]} played #{count} dice and got #{total}!"
    message.say results.join ' '
  end
end
