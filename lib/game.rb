# frozen_string_literal: true

require_relative './player'
require 'rainbow'

class Game
  def initialize
    @tiles = Array(1..9)
    @winning_combos = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
                       [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
    @turn_counter = 0
    @players = [Player.new, Player.new]
  end

  def create_players
    system('clear')

    @players.each_with_index do |player, i|
      get_player_info(player, i + 1)
    end
  end

  def get_player_info(player, number)
    player.get_name(number)

    number == 1 ? player.get_symbol(number) : player.get_symbol(number, @players[0].symbol)
  end

  def play
    until @turn_counter == 9
      turn_order

      break if game_over?

      @turn_counter += 1
    end

    determine_winner
  end

  def turn_order
    @turn_counter.even? ? play_turn(@players[0]) : play_turn(@players[1])
  end

  def play_turn(player)
    create_board

    loop do
      choice = player.get_choice

      if @tiles.include?(choice)
        update_tiles(choice, player.symbol)

        break
      else
        puts Rainbow('Error: Tile already picked.').color(:red)
      end
    end
  end

  def create_board
    system('clear')

    puts <<~HEREDOC
      == Open for business ==
      \t #{@tiles[0]} | #{@tiles[1]} | #{@tiles[2]}#{' '}
      \t---+---+---#{' '}
      \t #{@tiles[3]} | #{@tiles[4]} | #{@tiles[5]}#{' '}
      \t---+---+---#{' '}
      \t #{@tiles[6]} | #{@tiles[7]} | #{@tiles[8]}#{' '}
    HEREDOC
  end

  def update_tiles(choice, symbol)
    @tiles.map! { |tile| tile == choice ? symbol : tile }

    @winning_combos.each do |combo|
      combo.map! { |element| element == choice ? symbol : element }
    end
  end

  def game_over?
    @winning_combos.each do |combo|
      return true if combo.uniq.length == 1
    end

    false
  end

  def determine_winner
    create_board

    if @turn_counter == 9
      puts Rainbow('Draw!').color(:blue)
    elsif @turn_counter.even?
      puts Rainbow("Winner is #{@players[0].name}").color(:green)
    else
      puts Rainbow("Winner is #{@players[1].name}").color(:green)
    end
  end
end
