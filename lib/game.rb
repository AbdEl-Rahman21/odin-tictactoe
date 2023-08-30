# frozen_string_literal: true

require_relative './player'
require_relative './computer'
require_relative './display'
require 'rainbow'

class Game
  include Display

  def initialize
    @tiles = Array(1..9)
    @winning_combos = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7],
                       [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
    @turn_counter = 0
    @players = []
    @game_mode = :e # :e = easy,:n = normal, :h = hard
  end

  def select_players
    player_selection

    loop do
      choice = gets.chomp

      if ('1'..'4').include?(choice)
        assign_players(choice)

        break
      else
        puts Rainbow('Invalid input.').color(:red)
      end
    end
  end

  def assign_players(choice)
    case choice
    when '1'
      @players = [Player.new, Player.new]
    when '2'
      @players = [Computer.new, Player.new]
    when '3'
      @players = [Player.new, Computer.new]
    when '4'
      @players = [Computer.new, Computer.new]
    end
  end

  def select_difficulty
    difficulty_selection

    loop do
      choice = gets.chomp

      if ('1'..'3').include?(choice)
        assign_mode(choice)

        break
      else
        puts Rainbow('Invalid input.').color(:red)
      end
    end
  end

  def assign_mode(choice)
    case choice
    when '1'
      @game_mode = :e
    when '2'
      @game_mode = :n
    when '3'
      @game_mode = :h
    end
  end

  def create_players
    system('clear')

    select_difficulty if @players.any? { |e| e.instance_of?(Computer) }

    @players.each_with_index do |player, i|
      get_player_info(player, i + 1)
    end
  end

  def get_player_info(player, number)
    player.get_name(number)

    number == 1 ? player.get_symbol : player.get_symbol(@players[0].symbol)
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
    @turn_counter.even? ? play_turn(@players[0], @players[1].symbol) : play_turn(@players[1], @players[0].symbol)
  end

  def play_turn(player, enemy_symbol)
    create_board(@tiles)

    loop do
      choice = get_player_choice(player, enemy_symbol)

      if @tiles.include?(choice)
        update_tiles(choice, player.symbol)

        break
      else
        puts Rainbow('Error: Tile already picked.').color(:red)
      end
    end
  end

  def get_player_choice(player, enemy_symbol)
    return player.get_choice if player.instance_of?(Player)

    available = @tiles.filter { |tile| tile.instance_of?(Integer) }

    case @game_mode
    when :e
      player.get_choice_easy(available)
    when :n
      player.get_choice_normal(available, @winning_combos, enemy_symbol)
    when :h
      player.get_choice_hard(available, @winning_combos, enemy_symbol)
    end
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
    create_board(@tiles)

    if @turn_counter == 9
      puts Rainbow('Draw!').color(:blue)
    elsif @turn_counter.even?
      puts Rainbow("Winner is #{@players[0].name}").color(:green)
    else
      puts Rainbow("Winner is #{@players[1].name}").color(:green)
    end
  end
end
