class Game
    @@player_score = 0
    @@computer_score = 0
    @@second_computer_score = 0

    def initialize
        current_board = Board.new
        current_board.print_board

        play
    end

    def play
        player_mark = promt_player_mark
        players_turn = prompt_player_first

        computer_mark = player_mark == "o" ? "x" : "o"
        computers_turn = !players_turn

        player = Player.new(player_mark)
        computer = Player.new(computer_mark)

        while true
            if computers_turn
                computer.computer_select
            end

            while players_turn
                position = prompt_player_position

                state = player.add_mark(position[0], position[1])
                if state.nil?
                    next
                elsif !state
                    puts "You won!"
                    return
                else
                    break
                end
            end
            
            players_turn = !players_turn
            computers_turn = !computers_turn

            Board.print_board
            sleep 1
        end
        
    end

    def promt_player_mark
        puts "What mark do you want to have? (o or x)"
        player_mark = gets.chomp.downcase

        while !(player_mark == "o" || player_mark == "x") 
            puts "Please choose either 1 or 2"
            player_mark = gets.chomp
        end

        player_mark
    end

    def prompt_player_first
        puts "Would you like to be first? (y/...)"
        player_first = gets.chomp == "y" ? true : false
    end

    def prompt_player_position
        puts "Where would you like to put your mark? (1-9)"
        pos = gets.chomp.to_i

        while pos > 9 || pos < 1
            puts "Please choose a viable position on the board"
            pos = gets.chomp.to_i
        end

        if pos < 4
            return [0, pos-1]
        elsif pos < 7
            return [1, pos-4]
        else
            return [2, pos-7]
        end
    end
end

class Board

    def initialize
        @@board_state = Array.new(3) {Array.new(3) {" "}}
    end

    def self.board_state=board_stt 
        @@board_state = board_stt
    end

    def self.board_state
        return @@board_state
    end

    def print_board
        @@board_state.each_with_index do |row, i|
            puts row[0] + "   |   " + row[1] + "   |   " + row[2]

            unless i == 2
                puts "---------------------"
            end
        end
    end

    def self.print_board
        @@board_state.each_with_index do |row, i|
            puts row[0] + "   |   " + row[1] + "   |   " + row[2]

            unless i == 2
                puts "---------------------"
            end
        end
    end

    def add_mark(x, y, mark)
        if @@board_state[x][y] == " "
            @@board_state[x][y] = mark
        else 
            puts "That position is taken, please choose another."
            return nil
        end

        self.check_for_win(x, y, mark)
    end

    def self.get_empty_spots
        Board.board_state.reduce(Array.new) do |acc, row|
            row.each do |col|
                if col == " "
                    acc.push([Board.board_state.index(row), row.index(col)])
                end
            end
            acc
        end
    end

    def reset_board
        @@board_state = Array.new(3) {Array.new(3) {" "}}
    end

    # private
    def check_for_win(x, y, current_mark)
        win = false

        @@board_state[x].each do |mark|
            if mark != current_mark
                win = false
                break
            end

            win = true
        end

        unless win
            @@board_state.each do |row|
                mark = row[y]

                if mark != current_mark
                    win = false
                    break
                end

                win = true
            end
        end

        unless win
            if @@board_state[0][0] == @@board_state[1][1] && @@board_state[1][1] == @@board_state[2][2]
                win = true
            else @@board_state[0][2] == @@board_state[1][1] && @@board_state[1][1] == @@board_state[2][0]
                win = true
            end
        end

        return win
        
    end
end

class Player < Board
    attr_reader :mark

    def initialize(mark)
        @mark = mark
    end

    def add_mark(x, y)
        super(x, y, @mark)
    end

    def computer_select
        arr = Board.get_empty_spots

        random = rand(arr.length())
        pos = arr[random]

        add_mark(pos[0], pos[1])
    end
end

puts "Hello there!"
# game = Game.new
player = Player.new("x")
computer = Player.new("o")
board = Board.new

Board.board_state = [["o", "x", "o"], ['x', 'o', 'x'], ['x', 'x', 'o']]
board.print_board
puts board.check_for_win(0, 1, "x")