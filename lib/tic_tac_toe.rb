# frozen_string_literal: true

module Display
  WINNING_COMBOS = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [1, 4, 7],
    [2, 5, 8],
    [3, 6, 9],
    [1, 5, 9],
    [3, 5, 7]
  ].freeze

  def get_player(number)
    player_info = { name: '', symbol: '' }

    puts "Name of Player ##{number}: "

    player_info[:name] = gets.chomp

    loop do
      puts "Symbol of Player ##{number}: "

      player_info[:symbol] = gets.chomp

      break unless number == 2 && player_info[:symbol] == player1.symbol

      puts 'Symbol already picked'
    end

    player_info
  end

  def create_board(array)
    puts '== Open for business =='
    puts "\t #{array[0]} | #{array[1]} | #{array[2]} "
    puts "\t---+---+--- "
    puts "\t #{array[3]} | #{array[4]} | #{array[5]} "
    puts "\t---+---+--- "
    puts "\t #{array[6]} | #{array[7]} | #{array[8]} "
  end

  def get_choice(player)
    loop do
      puts "#{player}, enter your choice: "

      choice = gets.chomp.to_i

      return choice if (1..9).include?(choice)

      puts 'Error: Your choice must be form 1 to 9.'
    end
  end
end

class Game
  include Display

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
    @player1 = Players.new(info[:name], info[:symbol])

    system('clear')

    create_board(tiles)

    info = get_player(2)
    @player2 = Players.new(info[:name], info[:symbol])

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
      nil
    else
      puts 'Invalid choice'
    end
  end
end

class Players
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

Game.new.create_game
