module Board
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

  def create_board(array)
    puts <<~HEREDOC
      == Open for business ==
      \t #{array[0]} | #{array[1]} | #{array[2]}#{' '}
      \t---+---+---#{' '}
      \t #{array[3]} | #{array[4]} | #{array[5]}#{' '}
      \t---+---+---#{' '}
      \t #{array[6]} | #{array[7]} | #{array[8]}#{' '}
    HEREDOC
  end
end
