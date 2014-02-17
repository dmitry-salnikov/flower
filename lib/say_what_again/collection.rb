require 'ostruct'

module SayWhatAgain
  Collection = Class.new(OpenStruct) do
    def to_s
      "#{body} - #{quotee}"
    end
  end
end
