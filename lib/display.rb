# frozen_string_literal: true

require 'rainbow'

module Display
  def create_board(tiles)
    system('clear')

    puts <<~HEREDOC
      == Open for business ==
      \t #{tiles[0]} | #{tiles[1]} | #{tiles[2]}#{' '}
      \t---+---+---#{' '}
      \t #{tiles[3]} | #{tiles[4]} | #{tiles[5]}#{' '}
      \t---+---+---#{' '}
      \t #{tiles[6]} | #{tiles[7]} | #{tiles[8]}#{' '}
    HEREDOC
  end

  def player_selection
    system('clear')

    puts <<~HEREDOC
      [1] Human vs. Human
      [2] Computer vs. Human
      [3] Human vs. Computer
      [4] Computer vs. Computer
    HEREDOC
  end

  def difficulty_selection
    system('clear')

    puts Rainbow('[1] Easy').color(:green)
    puts Rainbow('[2] Normal').color(:blue)
    puts Rainbow('[3] Hard').color(:red)
  end
end
