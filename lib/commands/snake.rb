class Snake < Flower::Command
  respond_to "snake", "productivitystopper"
  GIF = "http://i.imgur.com/j58oizS.gif"

  def self.description
    "Productivity Stopper 2000"
  end

  def self.respond(message)
    message.say GIF
  end
end
