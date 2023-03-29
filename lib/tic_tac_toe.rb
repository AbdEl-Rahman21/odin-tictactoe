# frozen_string_literal: true

module Display
  LINES = [
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

    puts "Symbol of Player ##{number}: "

    player_info[:symbol] = gets.chomp

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

  attr_accessor :tiles, :player_1, :player_2, :winning_combo

  def initialize
    @tiles = Array(1..9)
    @winning_combo = LINES
  end

  def play
    system('clear')

    counter = 0
    win = false

    create_players

    loop do
      counter.even? ? play_turn(player_1) : play_turn(player_2)

      winning_combo.each { |combo| win = true if combo.uniq.length == 1 }

      if win
        create_board(tiles)

        if counter.even?
          puts "Winner is #{player_1.name}"

        else
          puts "Winner is #{player_2.name}"

        end
        break
      elsif counter == 8
        puts 'Draw'

        break
      end

      counter += 1
    end

    play_again
  end

  def create_players
    create_board(tiles)

    info = get_player(1)
    @player_1 = Players.new(info[:name], info[:symbol])

    system('clear')

    create_board(tiles)

    info = get_player(2)
    @player_2 = Players.new(info[:name], info[:symbol])

    system('clear')
  end

  def play_turn(player)
    create_board(tiles)

    loop do
      choice = get_choice(player.name)

      if tiles.include?(choice)
        tiles.map! { |tile| tile == choice ? tile = player.symbol : tile }

        winning_combo.each do |combo|
          combo.map! do |element|
            element == choice ? element = player.symbol : element
          end
        end

        break
      else
        puts 'Error: Tile already picked.'
      end
    end

    system('clear')
  end

  def play_again
    puts "Do you want to play again [Y\N]"

    choice = gets.chomp

    Game.new.play if choice.downcase == 'y'
  end
end

class Players
  attr_reader :name, :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end

Game.new.play
