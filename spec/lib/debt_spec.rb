require 'debt'

describe Debt do
  describe '#initialize' do
    context 'invalid parameters' do
      it 'raises an error if no `from` paramter is found' do
        expect { described_class.new to: 'batman', value: 1 }.to raise_error Debt::ParameterMissingError
      end

      it 'raises an error if no `to` parameter is found' do
        expect { described_class.new from: 'alfred', value: 1 }.to raise_error Debt::ParameterMissingError
      end
    end
  end

  describe '#create!' do
    context 'no previous debt' do
      let(:debt) { described_class.new to: 'batman', from: 'alfred', value: 1 }

      it 'saves the debt with an value of 1' do
        debt.should_receive(:save_to_database) { "OK" }
        debt.create!
      end
    end

    context 'previous debt' do
      let(:debt) { described_class.new to: 'batman', from: 'alfred', value: 1 }

      it 'saves the debt with an value of 2' do
        debt.should_receive(:save_to_database) { "OK" }
        debt.create!
      end

    end
  end
end
