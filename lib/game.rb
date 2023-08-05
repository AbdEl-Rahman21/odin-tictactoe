# frozen_string_literal: true

require_relative './player'
require_relative './board'

class Game
  include Board

  def initialize
    @tiles = Array(1..9)
    @winning_combos = WINNING_COMBOS
    @turn_counter = 0
    @game_over = false
  end

  def create_game
    system('clear')

    create_players

    play

    repeat
  end

  private

  attr_accessor :tiles,
                :winning_combos,
                :player1,
                :player2,
                :turn_counter,
                :game_over

  def play
    loop do
      turn_counter.even? ? play_turn(player1) : play_turn(player2)

      winning_combos.each do |combo|
        self.game_over = true if combo.uniq.length == 1
      end

      if game_over
        get_winner(turn_counter)

        break
      elsif turn_counter == 8
        puts 'Draw'

        break
      end

      self.turn_counter += 1
    end
  end

  def get_winner(turn_counter)
    create_board(tiles)

    if turn_counter.even?
      puts "Winner is #{player1.name}"
    else
      puts "Winner is #{player2.name}"
    end
  end

  def create_players
    create_board(tiles)

    info = get_player(1)
    @player1 = Player.new(info[:name], info[:symbol])

    system('clear')

    create_board(tiles)

    info = get_player(2)
    @player2 = Player.new(info[:name], info[:symbol])

    system('clear')
  end

  def play_turn(player)
    create_board(tiles)

    loop do
      choice = get_choice(player.name)

      if tiles.include?(choice)
        update_tiles(choice, player)

        break
      else
        puts 'Error: Tile already picked.'
      end
    end

    system('clear')
  end

  def update_tiles(choice, player)
    tiles.map! { |tile| tile == choice ? player.symbol : tile }

    winning_combos.each do |combo|
      combo.map! { |element| element == choice ? player.symbol : element }
    end
  end

  def repeat
    loop do
      puts 'Do you want to play again [Y\\N]'

      choice = gets.chomp.downcase

      handle_choice_repeat(choice)
    end
  end

  def handle_choice_repeat(choice)
    case choice
    when 'y'
      Game.new.create_game
    when 'n'
      exit
    else
      puts 'Invalid choice'
    end
  end
end
