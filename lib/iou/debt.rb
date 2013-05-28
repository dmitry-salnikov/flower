require 'redis'
require_relative 'key'
require 'pry'

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
      save_to_database == "OK"
    end

    def value
      (key.sender?(sender) ? amount : -amount) + previous_value
    end

    def previous_value
      redis.get(key.identifier).to_i
    end

    private

    def save_to_database
      redis.set key.identifier, value
    end

    def key
      @key ||= Key.new(sender: sender, receiver: receiver)
    end


    def redis
      @redis ||= Redis.new
    end
  end
end
