class Game
    def initialize
        @board = Array.new(10) { Array.new(10,".").clone }
        @ships = [0, 4, 3, 2, 1]
        @surrend = false
    end
    
    def check_count_ships?
        amount = 0
        @ships.each do |i|
            amount += i
        end

        if amount != 0
            return true
        end

        return false
    end

    def clear_field
        @board.each do |i|
            i.each do |j|
                j = "."
            end
        end

        return_ships()
    end

    def return_ships
        @ships = [0, 4, 3, 2, 1]
    end

    def testing_input_dock?(x, y)
        if x >= 0 && x <= 9 && y >= 0 && y <= 9
            tmpArrX = Array.new(9)
            tmpArrY = Array.new(9)

            tmpArrX[0] = x + 1
            tmpArrY[0] = y + 1

            tmpArrX[1]= x
            tmpArrY[1] = y + 1

            tmpArrX[2] = x - 1
            tmpArrY[2] = y + 1

            tmpArrX[3] = x + 1
            tmpArrY[3] = y

            tmpArrX[4] = x
            tmpArrY[4] = y

            tmpArrX[5] = x - 1
            tmpArrY[5] = y

            tmpArrX[6] = x + 1
            tmpArrY[6] = y - 1
            
            tmpArrX[7] = x
            tmpArrY[7] = y - 1

            tmpArrX[8] = x - 1
            tmpArrY[8] = y - 1

            (0..8).each do |i|
                if tmpArrX[i] > -1 && tmpArrY[i] > -1 && tmpArrX[i] < 10 && tmpArrY[i] < 10
                    if @board[tmpArrX[i]][tmpArrY[i]] == "S"
                        return false
                    end
                end
            end
            return true
        end
        return false
    end

    def testing_input_direct_ship(x, y, dirX, dirY, type)
        cordsArr = Array.new(type) { Array.new(2).clone }

        (0..type-1).each do |i|
            if testing_input_dock?(x, y)
                cordsArr[i][0] = x
                cordsArr[i][1] = y
            else
                return nil
            end
            x += dirX
            y += dirY
            
        end

        return cordsArr
    end

    def testing_input_ship(x, y, dir, type)
        cordsArr = Array.new(type) { Array.new(2).clone }
        
        if testing_input_dock?(x, y)
            case dir
            when 0
                cordsArr = testing_input_direct_ship(x, y, 1, 0, type)
                if cordsArr == nil
                    cordsArr = testing_input_direct_ship(x, y, -1, 0, type)
                end
            when 1
                cordsArr = testing_input_direct_ship(x, y, 0, 1, type)
                if cordsArr == nil
                    cordsArr = testing_input_direct_ship(x, y, 0, -1, type)
                end          
            end
            return cordsArr
        end
        return nil
    end

    def test_insert_ship?(x, y, dir, type)
        cordShip = testing_input_ship(x, y, dir, type)

        if cordShip != nil
            cordShip.each do |i|
                @board[i[0]][i[1]] = "S"
            end
            return true
        end
        return false
    end

    def init_ships_on_field

        startShip = 4
        cordX, cordY, dir = 0

        while check_count_ships?()
            cordX = rand(10)
            cordY = rand(10)
            direct = rand(2)

            if test_insert_ship?(cordX, cordY, direct, startShip)
                @ships[startShip] -= 1
                if @ships[startShip] == 0
                    startShip -= 1
                end
            end
        end
    end
    
    def print_fields
        puts '   A B C D E F G H I J'
        iter = 0
        @board.each do |row|
            string = ''
            row.each do |v|
                if !@surrend && (v == "S" || v == ".")
                    string += " ."
                else
                    string += " #{v}"
                end
            end

            iter += 1

            iter < 10 ? string = "#{iter} #{string}" : string = "#{iter}#{string}"

            puts string
        end
    end

    def try_shoot(x, y)
        if @board[x][y] == "S"
            @board[x][y] = "x"
        elsif @board[x][y] == "."
            @board[x][y] = "o"
        end
    end

    def chek_finish?
        @board.each do |i|
            if i.include?("S")
                return false
            end
        end
        return true
    end

    def chek_user_input?(cord)
        cord = cord.gsub(' ', '')
        if cord.match(/^[a-jA-J][1-9]0*$/)
            case cord.length
            when 2
                return true
            when 3
                if cord.split("")[1].to_i == 1
                    return true
                end
            end
        end
        return false
    end

    def user_input
        puts "Enter the coordinates of the ship:"
        cord = gets.chomp.downcase
        if cord == "surrender"
            puts `clear`
            puts "What a shame…"
            puts
            @surrend = true
            print_fields()
            return nil
        end

        loop do
            if chek_user_input?(cord)
                break
            end
            puts "Incorrect coordinate!"
            puts "\nEnter the coordinates of the ship:"
            cord = gets.chomp
        end

        case cord.length
        when 2
            cordY = cord.split("")[0]
            cordX = cord.split("")[1].to_i - 1
        when 3
            if cord.split("")[1].to_i == 1
                cordY = cord.split("")[0]
                cordX = "#{cord.split("")[1]}#{cord.split("")[2]}".to_i - 1
            end
        end

        case cordY
        when "a"
            cordY = 0
        when "b"
            cordY = 1
        when "c"
            cordY = 2
        when "d"
            cordY = 3
        when "e"
            cordY = 4
        when "f"
            cordY = 5
        when "g"
            cordY = 6
        when "h"
            cordY = 7
        when "i"
            cordY = 8
        when "j"
            cordY = 9
        end

        return cordX, cordY

    end

    def start_game
        init_ships_on_field()
        loop do
            puts `clear`
            print_fields()
            puts
            inputCords = user_input()
            if inputCords == nil
                break
            end

            try_shoot(inputCords[0], inputCords[1])

            if chek_finish?()
                puts "You win!"
                break
            end
        end
    end
end

g = Game.new
g.start_game