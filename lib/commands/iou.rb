# encoding: utf-8
require_relative '../debt'

class IOU < Flower::Command
  respond_to "iou"

  class << self
    def description
      "Your bank™, in your chat!"
    end

    def respond message
      from = message.sender[:nick].downcase
      to = message.argument.split(" ").first.downcase
      amount = message.argument.split(" ")[1].to_i

      Debt.new(from: from, to: to, amount: amount).create!
    end
  end
end
