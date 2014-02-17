require 'say_what_again/collection'

describe SayWhatAgain::Collection do
  describe '#to_s' do
    let(:quote) { { body: "Say what again!", quotee: "Jules" } }

    it 'returns a string representation of the collection' do
      collection = described_class.new quote
      expect(collection.to_s).to eq "Say what again! - Jules"
    end
  end
end
