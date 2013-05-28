module IOU
  class Key
    attr_reader :sender, :receiver

    def initialize opts = {}
      @sender = opts[:sender].downcase
      @receiver = opts[:receiver].downcase
    end

    def identifier
      "#{sender}-#{receiver}".split("-").sort.join("-")
    end

    def sender? person
      identifier.split('-').first == person.downcase
    end
  end
end