require 'iou/debt'

describe IOU::Debt do
  describe '#initialize' do
    context 'invalid parameters' do
      it 'raises an error if no `sender` paramter is found' do
        expect { described_class.new receiver: 'batman', amount: 1 }.to raise_error IOU::Debt::ParameterMissingError
      end

      it 'raises an error if no `receiver` parameter is found' do
        expect { described_class.new sender: 'alfred', amount: 1 }.to raise_error IOU::Debt::ParameterMissingError
      end
    end
  end

  describe '#create!' do

    let(:debt) { described_class.new sender: 'Batman', receiver: 'Alfred', amount: 10 }

    context 'no previous amount' do
      it "should create" do
        Redis.any_instance.should_receive(:set).with(debt.send(:key).identifier, -10).and_return "OK"
        debt.should_receive(:previous_amount) { 0 }
        debt.create!
      end
    end

    context 'previous amount' do
      it "should create" do
        debt.should_receive(:previous_amount) { -10 }
        Redis.any_instance.should_receive(:set).with(debt.send(:key).identifier, -20).and_return "OK"
        debt.create!
      end
    end
  end

  describe '#value' do
    let(:debt) { described_class.new sender: 'alfred', receiver: 'batman', amount: 10 }

    context 'sets a the amount based on the sender and the key' do
      it 'sets a positive amount' do
        debt.value.should == 10
      end

      it 'sets a negative amount' do
        debt = described_class.new sender: 'batman', receiver: 'alfred', amount: 10
        debt.value.should == -10
      end
    end
  end
end
