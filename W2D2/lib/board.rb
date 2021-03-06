class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @name1 = name1
    @name2 = name2
    @cups = Array.new(14) {Array.new}
    place_stones
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    @cups.each_with_index do |cup, idx|
      next if idx == 6 || idx == 13
      4.times do
        cup << :stone
      end
    end
  end

  def valid_move?(start_pos)
    if start_pos < 0 || start_pos > 12
      raise "Invalid starting cup"
    end

    if @cups[start_pos].empty?
      raise "Invalid starting cup"
    end
  end

  def make_move(start_pos, current_player_name)
    stones = @cups[start_pos]
    @cups[start_pos] = []

    start_idx = start_pos
    until stones.empty?
      start_idx += 1
      start_idx = 0 if start_idx > 13
      if start_idx == 6
        @cups[6] << stones.pop if current_player_name == @name1
      elsif start_idx == 13
        @cups[13] << stones.pop if current_player_name == @name2
      else
        @cups[start_idx] << stones.pop
      end
    end

    render
    next_turn(start_idx)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine what #make_move returns
    if ending_cup_idx == 6 || ending_cup_idx == 13
      :prompt
    elsif @cups[ending_cup_idx].count == 1
      :switch
    else
      ending_cup_idx
    end
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..6].all? { |cup| cup.empty? } || @cups[7..-1].all? { |cup| cup.empty?}
  end

  def winner
    player1_score = @cups[6].length
    player2_score = @cups[13].length

    if player1_score == player2_score
      :draw
    else
      if player1_score > player2_score
        @name1
      else
        @name2
      end
    end
  end
end
