# frozen_string_literal: true

class Computer
  attr_reader :name, :symbol

  def initialize
    @name = ''
    @symbol = ''
  end

  def get_name(number)
    @name = "Computer #{number}"
  end

  def get_symbol(picked_symbol = '')
    symbols = ['!', '@', '#', '$', '%', '&', '=']

    symbols.delete(picked_symbol)

    @symbol = symbols.sample
  end

  def get_choice_hard(tiles, combos, enemy_symbol)
    choice = can_win(combos)

    return choice unless choice.nil?

    choice = can_lose(combos, enemy_symbol)

    return choice unless choice.nil?

    choice = diagonal_priority(tiles, [combos[6], combos[7]], enemy_symbol)

    return choice unless choice.nil?

    tiles.sample
  end

  def get_choice_normal(tiles, combos, enemy_symbol)
    choice = can_win(combos)

    return choice unless choice.nil?

    choice = can_lose(combos, enemy_symbol)

    return choice unless choice.nil?

    return 5 if tiles.include?(5)

    tiles.sample
  end

  def get_choice_easy(tiles)
    tiles.sample
  end

  def all_string?(combo)
    return true if combo.all? { |e| e.instance_of?(String) }

    false
  end

  def first_number(combo)
    combo[combo.index { |e| e.instance_of?(Integer) }]
  end

  def can_win(combos)
    combos.each do |combo|
      next if all_string?(combo)

      return first_number(combo) if combo.count(@symbol) == 2
    end

    nil
  end

  def can_lose(combos, enemy_symbol)
    combos.each do |combo|
      next if all_string?(combo)

      return first_number(combo) if combo.count(enemy_symbol) == 2
    end

    nil
  end

  def diagonal_priority(tiles, diagonals, enemy_symbol)
    diagonals.each do |combo|
      if combo == [enemy_symbol, @symbol, enemy_symbol]

        return tiles[tiles.index(&:even?)]

      elsif !all_string?(combo)

        return first_number(combo)

      end
    end

    nil
  end
end
