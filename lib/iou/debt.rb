require 'redis'

module IOU
  class Debt
    class ParameterMissingError < StandardError; end

    attr_reader :sender, :receiver, :amount

    def initialize opts = {}
      @sender = opts.fetch(:sender) { raise Debt::ParameterMissingError }
      @receiver = opts.fetch(:receiver) { raise Debt::ParameterMissingError }
      @amount = opts[:amount]
    end

    def create!
      save_to_database
    end

    def balance
      amount_depending_on_sender amount_from_database
    end

    private

    def save_to_database
      redis.set key.identifier, new_balance
    end

    def new_balance
      amount_depending_on_sender + balance
    end

    def amount_from_database
      redis.get(key.identifier).to_i
    end

    def amount_depending_on_sender money = amount
      key.sender?(sender) ? money : -money
    end

    def key
      @key ||= Key.new(sender: sender, receiver: receiver)
    end

    def redis
      @redis ||= Redis.new
    end
  end
end
