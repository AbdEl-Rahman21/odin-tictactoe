# frozen_string_literal: true

require 'rainbow'

class Player
  attr_reader :name, :symbol

  def initialize
    @name = ''
    @symbol = ''
  end

  def get_name(number)
    print "Enter name of Player ##{number}: "

    @name = gets.chomp
  end

  def get_symbol(number, picked_symbol = '')
    loop do
      print "Enter symbol (single character) of Player ##{number}: "

      @symbol = gets.chomp

      break unless @symbol.length != 1 || @symbol == picked_symbol || @symbol == ' ' || @symbol.between?('0', '9')

      puts Rainbow('Invalid symbol!').color(:red)
    end
  end

  def get_choice
    loop do
      print "#{@name}, enter your choice: "

      choice = gets.chomp

      return choice.to_i if choice.length == 1 && choice.between?('1', '9')

      puts Rainbow('Error: Your choice must be form 1 to 9.').color(:red)
    end
  end
end
