class Board
    attr_accessor :grid
    def initialize
        @grid = [
            [" ", " ", " "],
            [" ", " ", " "],
            [" ", " ", " "]
        ]
    end

    def insert_marker(marker, row, column)
        row = row.to_i
        column = column.to_i
        @grid[row - 1][column - 1] = marker
    end

    def show
        puts ""
        puts (@grid[0][0].to_s + ' | ' + @grid[0][1].to_s + ' | ' + @grid[0][2].to_s)
        puts '- - - - -'
        puts (@grid[1][0].to_s + ' | ' + @grid[1][1].to_s + ' | ' + @grid[1][2].to_s)
        puts '- - - - -'
        puts (@grid[2][0].to_s + ' | ' + @grid[2][1].to_s + ' | ' + @grid[2][2].to_s)
        puts ""
    end

    def invalid_entry?(entry)
        entry = entry.to_i
        [1,2,3].include?(entry) ? false : true
    end

    def occupied_row?(row)
        row = row.to_i
        @grid[row - 1].any?(" ") ? false : true
    end

    def occupied_entry?(row, column)
        row = row.to_i
        column = column.to_i
        @grid[row - 1][column - 1] == " " ? false : true
    end

    def clear
        @grid.map! { |row| row = [" ", " ", " "] }
    end
end

class Player
    attr_reader :temp_name
    attr_accessor :name, :marker
    def initialize(temp_name)
        @temp_name = temp_name
        @score = 0
    end

    def get_name
        puts "#{@temp_name}, what's your name?"
        @name = gets.chomp
        puts "Welcome, #{@name}!"
    end

    def get_marker
        puts "And what marker would you like to use?"
        print "Please enter one character: "
        @marker = gets.chomp
        while invalid_char?(@marker)
            print "Please enter a valid character: "
            @marker = gets.chomp
        end
    end

    private

    def invalid_char?(char)
        char.length != 1 ? true : false
    end
end

class TicTacToe
    def initialize
        @board = Board.new
        @player1 = Player.new("Player1")
        @player2 = Player.new("Player2")
        @game_active = true
    end

    public

    def play
        puts "Welcome to tic-tac-toe!"
        @player1.get_name
        @player1.get_marker
        @player2.get_name
        @player2.get_marker
        while @player2.marker == @player1.marker
            print "Hey, that's #{@player1.name}'s marker! Please choose a different one: '"
            @player2.marker = gets.chomp
        end
        @board.show
        loop do
          play_round()
        end
    end

    private
    
    def play_round
        take_turn(@player1)
        check_winner(@player1)
        take_turn(@player2)
        check_winner(@player2)
    end

    def take_turn(player)
        puts "#{player.name}, enter a row and column for your turn (numbering starts at 1)."
        print "Row: "
        row = gets.chomp
        while @board.invalid_entry?(row) || @board.occupied_row?(row)
            print "Please enter a valid row: "
            row = gets.chomp
        end
        print "Column: "
        column = gets.chomp
        while @board.invalid_entry?(column) || @board.occupied_entry?(row, column)
            print "Please enter a valid column: "
            column = gets.chomp
        end
        @board.insert_marker(player.marker, row, column)
        @board.show
    end

    def check_winner(player)
        marker = player.marker
        if check_across(marker) || check_down(marker) || check_diagonal(marker)
            winner_message(player)
            check_play_again
        elsif cats_game?
            cats_game_message
            check_play_again
        end
    end

    def winner_message(player)
        puts "Congrats, #{player.name.chomp}! You win!"
    end

    def check_play_again
        if play_again?
            reset
            play
        else
            puts "Thanks for playing!"
            exit
        end
    end

    def play_again?
        response = ""
        while (response != 'y' && response != 'n' && response != 'yes' && response != 'no')
            puts "Play again? y/n"
            response = gets.chomp.downcase
        end
        response == 'y' || response == 'yes' ? true : false
    end

    def cats_game?
        @board.grid.flatten.none?(" ") ? true : false
    end

    def cats_game_message
        puts "It's a cat's game!"
    end

    def reset
        @board.clear
        @player1.name = nil
        @player1.marker = nil
        @player2.name = nil
        @player2.marker = nil
        @winner = false
    end

    def check_across(marker)
      @board.grid.each do |row|
        if [row[0], row[1], row[2]].all?(marker)
            return true
        end
    end
        false
    end

    def check_down(marker)
        @board.grid.transpose.each do |col|
            if [col[0], col[1], col[2]].all?(marker)
                return true
            end
        end
        false
    end

    def check_diagonal(marker)
        grid = @board.grid
        if [grid[0][0], grid[1][1], grid[2][2]].all?(marker)
            true
        elsif [grid[0][2], grid[1][1], grid[2][0]].all?(marker)
            true
        else
            false
        end 
    end
end

tic_tac_toe = TicTacToe.new
tic_tac_toe.play
