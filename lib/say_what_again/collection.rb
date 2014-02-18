require 'ostruct'

module SayWhatAgain
  Collection = Class.new(OpenStruct) do
    def to_s
      if context
        "#{body} - #{quotee} about #{context}"
      else
        "#{body} - #{quotee}"
      end
    end
  end
end
