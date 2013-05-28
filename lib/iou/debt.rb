require 'redis'
require 'iou/key'
require 'pry'

module IOU
  class Debt
    class ParameterMissingError < StandardError; end

    attr_reader :receiver, :sender, :amount

    def initialize opts = {}
      @sender = opts.fetch(:sender) { raise Debt::ParameterMissingError }
      @receiver = opts.fetch(:receiver) { raise Debt::ParameterMissingError }
      @amount = opts[:amount]
    end

    def create!
      save_to_database
    end

    def value
      (key.sender?(sender) ? amount : -amount) + previous_value
    end

    private

    def save_to_database
      redis.set key.identifier, value
    end

    def previous_value
      redis.get(key.identifier).to_i
    end

    def key
      Key.new(sender: sender, receiver: receiver)
    end


    def redis
      @redis ||= Redis.new
    end
  end
end
