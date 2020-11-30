class Game
    attr_accessor :board, :player_1, :player_2

    WIN_COMBINATIONS = 
    [[0,1,2],  # Top row
     [3,4,5],  # Middle row
     [6,7,8],  # Bottom row
     [0,4,8],  # Diagonal 1
     [2,4,6],  # Diagonal 2
     [0,3,6],  # Column 1
     [1,4,7],  # Column 2
     [2,5,8],] # Column 3

    def initialize(player_1 = Players::Human.new("X"), player_2 = Players::Human.new("O"), board = Board.new)
        @player_1 = player_1
        @player_2 = player_2
        @board = board
    end

    def current_player
        @board.turn_count % 2 == 0 ? @player_1 : @player_2
    end

    def won?
        WIN_COMBINATIONS.detect do |win_combination|
            @board.cells[win_combination[0]] == @board.cells[win_combination[1]] &&
            @board.cells[win_combination[1]] == @board.cells[win_combination[2]] &&
            @board.taken?(win_combination[0]+1)
          end
          
    end

    def draw?
        @board.full? && !won?
    end

    def over?
        draw? || won?
    end

    def winner
        if win_combination = won?
            @winner = @board.cells[win_combination.first]
        end
    end

    def turn
        player = current_player
        current_move = player.move(@board)
        if !@board.valid_move?(current_move)
            turn
        else
            puts "Turn: #{@board.turn_count+1}\n"
            @board.display
            @board.update(current_move, player)
            puts "#{player.token} moved #{current_move}\n"
            @board.display
        end
    end

    def play
        while !over?
            turn
        end
        if won?
            puts "Congratulations #{winner}!"
        elsif draw?
            puts "Cat's Game!"
        end
    end

end