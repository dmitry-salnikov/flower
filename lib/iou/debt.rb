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

    def value
      amount_depending_on_sender + previous_amount
    end

    def previous_amount
      redis.get(key.identifier).to_i
    end

    private

    def save_to_database
      redis.set key.identifier, value
    end

    def amount_depending_on_sender
      key.sender?(sender) ? amount : -amount
    end

    def key
      @key ||= Key.new(sender: sender, receiver: receiver)
    end

    def redis
      @redis ||= Redis.new
    end
  end
end
