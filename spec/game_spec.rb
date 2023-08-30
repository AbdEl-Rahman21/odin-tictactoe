# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require 'rainbow'

describe Game do
  describe '#get_player_info' do
    subject(:game_players) { described_class.new }
    let(:players_info) { instance_double(Player) }
    let(:player1) { double('Player', symbol: 'x') }

    context "when its player2's turn to choose their symbol" do
      before do
        game_players.instance_variable_set(:@players, [player1])
        allow(players_info).to receive(:get_name)
      end

      it "calls #get_symbol with the player1's symbol" do
        player_number = 2
        player1_symbol = 'x'
        expect(players_info).to receive(:get_symbol).with(player1_symbol)
        game_players.get_player_info(players_info, player_number)
      end
    end
  end

  describe '#play' do
    subject(:game_loop) { described_class.new }

    context 'when turn_counter equals 9' do
      before do
        game_loop.instance_variable_set(:@turn_counter, 9)
        allow(game_loop).to receive(:game_over?).and_return(false)
      end

      it 'calls #determine_winner' do
        expect(game_loop).to receive(:determine_winner)
        game_loop.play
      end
    end

    context 'when #game_over? is false twice' do
      before do
        allow(game_loop).to receive(:game_over?).and_return(false, false, true)
        allow(game_loop).to receive(:determine_winner)
      end

      it 'calls #turn_order thrice' do
        expect(game_loop).to receive(:turn_order).thrice
        game_loop.play
      end
    end

    context 'when #game_over? is true' do
      before do
        allow(game_loop).to receive(:game_over?).and_return(true)
        expect(game_loop).to receive(:turn_order)
      end

      it 'calls #determine_winner' do
        expect(game_loop).to receive(:determine_winner)
        game_loop.play
      end
    end
  end

  describe '#play_turn' do
    subject(:game_turn) { described_class.new }
    let(:player_choice) { instance_double(Player) }

    context 'when player enters two invalid inputs' do
      before do
        player_symbol = 'x'
        picked_tiles = [4, 7]
        valid_tile = 1
        game_turn.instance_variable_set(:@tiles, [1, 2, 3, player_symbol, 5, 6, player_symbol, 8, 9])
        allow(player_choice).to receive(:symbol).and_return(player_symbol)
        allow(game_turn).to receive(:create_board)
        allow(game_turn).to receive(:update_tiles)
        allow(game_turn).to receive(:get_player_choice).and_return(picked_tiles[0], picked_tiles[1], valid_tile)
      end

      it 'displays error massage twice' do
        enemy_symbol = 'o'
        massage = Rainbow('Error: Tile already picked.').color(:red)
        expect(game_turn).to receive(:puts).with(massage).twice
        game_turn.play_turn(player_choice, enemy_symbol)
      end
    end

    context 'when player enters a valid input' do
      before do
        player_symbol = 'x'
        valid_tile = 1
        allow(player_choice).to receive(:symbol).and_return(player_symbol)
        allow(game_turn).to receive(:get_player_choice).and_return(valid_tile)
        allow(game_turn).to receive(:create_board)
      end

      it 'calls #update_tiles' do
        enemy_symbol = 'o'
        expect(game_turn).to receive(:update_tiles).with(1, 'x')
        game_turn.play_turn(player_choice, enemy_symbol)
      end
    end
  end

  describe '#update_tiles' do
    subject(:game_tiles) { described_class.new }

    it 'replace a tile with the player symbol' do
      tiles = game_tiles.instance_variable_get(:@tiles)
      player_choice = 4
      player_symbol = 'x'
      updated_tiles = [1, 2, 3, 'x', 5, 6, 7, 8, 9]
      expect { game_tiles.update_tiles(player_choice, player_symbol) }.to change { tiles }.to(updated_tiles)
    end

    it 'replace a tile in a combo with the player symbol' do
      combos = game_tiles.instance_variable_get(:@winning_combos)
      player_choice = 4
      player_symbol = 'x'
      updated_combos = [[1, 2, 3], ['x', 5, 6], [7, 8, 9], [1, 'x', 7],
                        [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
      expect { game_tiles.update_tiles(player_choice, player_symbol) }.to change { combos }.to(updated_combos)
    end
  end

  describe '#game_over?' do
    subject(:game_end) { described_class.new }

    context 'when there is a winning combo' do
      before do
        game_end.instance_variable_set(:@winning_combos, [[1, 2, 3], [4, 5, 6], %w[x x x]])
      end

      it 'returns true' do
        expect(game_end).to be_game_over
      end
    end

    context "when there isn't a winning combo" do
      it 'returns false' do
        expect(game_end).not_to be_game_over
      end
    end
  end
end
