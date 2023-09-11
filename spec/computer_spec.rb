# frozen_string_literal: true

require_relative '../lib/computer'

describe Computer do
  describe '#get_choice_hard' do
    subject(:computer_choice) { described_class.new }
    let(:tiles) { [3] }
    let(:combos) do
      [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
       [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
    end
    let(:enemy_symbol) { 'o' }

    context 'when #can_win returns a number' do
      before do
        allow(computer_choice).to receive(:can_win).and_return(3)
      end

      it 'returns the number' do
        expect(computer_choice.get_choice_hard(tiles, combos, enemy_symbol)).to eq(3)
      end
    end

    context 'when #can_lose returns a number' do
      before do
        allow(computer_choice).to receive(:can_win).and_return(nil)
        allow(computer_choice).to receive(:can_lose).and_return(3)
      end

      it 'returns the number' do
        expect(computer_choice.get_choice_hard(tiles, combos, enemy_symbol)).to eq(3)
      end
    end

    context 'when middle is available' do
      before do
        allow(computer_choice).to receive(:can_win).and_return(nil)
        allow(computer_choice).to receive(:can_lose).and_return(nil)
      end

      it 'returns the 5' do
        tiles = [1, 2, 5]
        expect(computer_choice.get_choice_hard(tiles, combos, enemy_symbol)).to eq(5)
      end
    end

    context 'when #diagonal_priority returns a number' do
      before do
        allow(computer_choice).to receive(:can_win).and_return(nil)
        allow(computer_choice).to receive(:can_lose).and_return(nil)
        allow(computer_choice).to receive(:diagonal_priority).and_return(9)
      end

      it 'returns the number' do
        expect(computer_choice.get_choice_hard(tiles, combos, enemy_symbol)).to eq(9)
      end
    end

    context 'when all the previous return nil' do
      before do
        allow(computer_choice).to receive(:can_win).and_return(nil)
        allow(computer_choice).to receive(:can_lose).and_return(nil)
        allow(computer_choice).to receive(:diagonal_priority).and_return(nil)
      end

      it 'returns a random tile' do
        expect(computer_choice.get_choice_hard(tiles, combos, enemy_symbol)).to eq(3)
      end
    end
  end

  describe '#can_win' do
    subject(:computer_win) { described_class.new }

    context 'when computer can win' do
      it 'returns winning tile' do
        combos = [[1, 'x', 3], ['o', 'x', 6], ['x', 5, 'x'], [1, 4, 7]]
        computer_win.instance_variable_set(:@symbol, 'x')
        expect(computer_win.can_win(combos)).to eq(5)
      end
    end

    context "when computer can't win" do
      it 'returns nil' do
        combos = [[1, 'x', 3], ['o', 'x', 6], ['o', 5, 'x'], [1, 4, 7]]
        computer_win.instance_variable_set(:@symbol, 'x')
        expect(computer_win.can_win(combos)).to be_nil
      end
    end
  end

  describe '#can_lose' do
    subject(:computer_lose) { described_class.new }

    context 'when computer can lose' do
      it 'returns blocking tile' do
        combos = [[1, 'x', 3], ['o', 'x', 6], ['x', 5, 'x'], [1, 4, 7]]
        enemy_symbol = 'x'
        expect(computer_lose.can_lose(combos, enemy_symbol)).to eq(5)
      end
    end

    context "when enemy can't win" do
      it 'returns nil' do
        combos = [[1, 'x', 3], ['o', 'x', 6], ['o', 5, 'x'], [1, 4, 7]]
        enemy_symbol = 'x'
        expect(computer_lose.can_lose(combos, enemy_symbol)).to be_nil
      end
    end
  end

  describe '#diagonal_priority' do
    subject(:computer_diagonal) { described_class.new }

    context "when a diagonal has te following sequence 'xox' where 'x' is the enemy symbol" do
      it 'returns an even tile' do
        tiles = [2, 3, 7]
        combos = [%w[x o x], [3, 'o', 7]]
        computer_diagonal.instance_variable_set(:@symbol, 'o')
        enemy_symbol = 'x'
        expect(computer_diagonal.diagonal_priority(tiles, combos, enemy_symbol)).to eq(2)
      end
    end

    context "when a diagonal isn't full" do
      before do
        allow(computer_diagonal).to receive(:all_string?).and_return(false)
      end

      it 'returns the empty tile in it' do
        tiles = [2, 3, 7]
        combos = [['x', 'o', 9], [3, 'o', 7]]
        computer_diagonal.instance_variable_set(:@symbol, 'o')
        enemy_symbol = 'x'
        expect(computer_diagonal.diagonal_priority(tiles, combos, enemy_symbol)).to eq(9)
      end
    end

    context "when there isn't an empty diagonal" do
      before do
        allow(computer_diagonal).to receive(:all_string?).and_return(true)
      end

      it 'returns nil' do
        tiles = [2, 3, 7]
        combos = [%w[x o o], %w[o o x]]
        computer_diagonal.instance_variable_set(:@symbol, 'o')
        enemy_symbol = 'x'
        expect(computer_diagonal.diagonal_priority(tiles, combos, enemy_symbol)).to be_nil
      end
    end
  end
end
