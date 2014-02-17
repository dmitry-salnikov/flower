require 'say_what_again/api'
require 'say_what_again/http'

describe SayWhatAgain::Api do
  let(:api) { described_class.new "http://myurl.com" }

  describe '#quotes' do
    it 'returns a list of objects representations' do
      allow_any_instance_of(SayWhatAgain::HTTP).to receive(:get) { dummy_response }

      expect(api.quotes.sample).to be_a_kind_of OpenStruct
    end
  end

  describe '#create' do
    it 'creates a quote remotely' do
      allow_any_instance_of(SayWhatAgain::HTTP).to receive(:post) { dummy_response }

      api.create
    end
  end

  def dummy_response
    Class.new {
      def body
        "{\"quotes\":[{\"id\":0,\"body\":\"1\",\"quotee\":\"2\",\"context\":\"3\"}]}"
      end
    }.new
  end
end
