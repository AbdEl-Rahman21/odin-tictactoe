require_relative '../lib/player'
require 'rainbow'

describe Player do
  describe '#get_symbol' do
    subject(:player_info) { described_class.new }

    context 'when user inputs four invalid inputs, then a valid input' do
      before do
        invalid = ['sfv', 'o', ' ', '8']
        valid = 'x'
        allow(player_info).to receive(:gets).and_return(invalid[0], invalid[1], invalid[2], invalid[3], valid)
        allow(player_info).to receive(:print)
      end

      it 'completes loop and displays error message four times' do
        expect(player_info).to receive(:puts).with(Rainbow('Invalid symbol!').bg(:red)).exactly(4).times
        player_info.get_symbol(1, 'o')
      end
    end
  end

  describe '#get_choice' do
    subject(:player_choice) { described_class.new }

    context 'when user inputs three invalid inputs, then a valid input' do
      before do
        invalid = ['0', '22', '$']
        valid = '4'
        allow(player_choice).to receive(:print)
        allow(player_choice).to receive(:gets).and_return(invalid[0], invalid[1], invalid[2], valid)
      end

      it 'completes loop and displays error massage three times' do
        expect(player_choice).to receive(:puts).with(Rainbow('Error: Your choice must be form 1 to 9.').bg(:red))
                                               .exactly(3).times
        player_choice.get_choice
      end
    end
  end
end
