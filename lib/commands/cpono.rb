# encoding: UTF-8
class Cpono < Flower::Command
  respond_to "cpono"

  def self.description
    "The CPO says no."
  end

  def self.respond(message)
    message.say "http://loopcam-uploads.s3.amazonaws.com/files/110917/original/loop.gif"
  end
end