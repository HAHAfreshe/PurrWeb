class Game
    def initialize
        @board = Array.new(10) { Array.new(10,".").clone } # игровое поле
        @ships = [0, 4, 3, 2, 1] # корабли
        @surrend = false # сдался ли игрок
    end

    # подстчет кол-ва кораблей в доке
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

    # очистка игрового поля
    def clear_field
        @board.each do |i|
            i.each do |j|
                j = "."
            end
        end

        return_ships()
    end

    # возвращение кораблей в док
    def return_ships
        @ships = [0, 4, 3, 2, 1]
    end

    # функция проверки установки палубы
    # проверяет саму клетку и клетки вокруг на возможность установить палубу
    # создает 2 массива с координатами по x и по y
    # затем проверяем возможность установить палубу
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

    # функция проверки установки корабля в зависимости от направления
    # запускаем цикл с кол-вом палуб корабля (type-1)
    # и пробуем поставить следующую за палубу
    # если получилось установитьь все палубы - возвращяем массив координат этих палуб
    def testing_input_direct_ship(x, y, dirX, dirY, type)
        cordsArr = Array.new(type) { Array.new(2).clone } # временный массив координат

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

    # функция проверки установки корабля по данным координатам
    # проверяет, возможно ли поставить палубу корабля
    # затем в зависимости от направления получает полные кординаты корабля из функции testing_input_direct_ship
    def testing_input_ship(x, y, dir, type)
        cordsArr = Array.new(type) { Array.new(2).clone } # временный массив координат

        if testing_input_dock?(x, y)
            case dir
            when 0
                # попытка поставить корабль "вниз" по координате x
                cordsArr = testing_input_direct_ship(x, y, 1, 0, type)
                # если не получилось поставить "вниз", пробуем поставить "вверх"
                if cordsArr == nil
                    cordsArr = testing_input_direct_ship(x, y, -1, 0, type)
                end
            when 1
                # попытка поставить корабль "вправо" по координате x
                cordsArr = testing_input_direct_ship(x, y, 0, 1, type)
                if cordsArr == nil
                    # если не получилось поставить "вправо", пробуем поставить "влево"
                    cordsArr = testing_input_direct_ship(x, y, 0, -1, type)
                end
            end
            # возвращяем массив координат
            return cordsArr
        end
        return nil
    end

    # функция попытки установки корабля на поля
    # получает массив координат, куда нужно установить корабль из функции testing_input_ship
    # затем, если массив не пустой - ставит корабль
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

    # функция создания рандомных кораблей на поле
    # startShip - с какого типа корабля нужно начинать
    # записывает рандомные координаты (от 0 до 9) и рандомное направление
    # 0 - по горизонтали
    # 1 - по вертикали
    # затем пробует поставить корабль, и если все хорошо - отнимает кол-во
    # данного типа коробля из массива кораблей
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

    # функция вывода игрового поля
    # перебирает массив и создает строку, которую должен вывести
    # также проверяет, сдался ли пользователь, чтоб вывести
    # игровое поле с отображение кораблей/промахов и попаданий
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

    # функция выстрела
    # в зависимости от попадания или промаха
    # вносит нужное значение в матрицу поля
    def try_shoot(x, y)
        if @board[x][y] == "S"
            @board[x][y] = "x"
        elsif @board[x][y] == "."
            @board[x][y] = "o"
        end
    end

    # функция проверки окончания игры
    # перебирает массив и проверяет на наличие кораблей
    def chek_finish?
        @board.each do |i|
            if i.include?("S")
                return false
            end
        end
        return true
    end

    #  функция проверки ввода
    # принимает в качестве аргумента координату, введеную пользователем
    # если она соответсвует регулярному выражению или же
    # пользователь ввел "surrender", то возврощяем true/nil
    def chek_user_input?(cord)
        cord = cord.gsub(' ', '')

        if cord == "surrender"
            puts `clear`
            puts "What a shame…"
            puts
            @surrend = true
            print_fields()
            return nil
        end

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

    # функция ввода пользователя
    # Проверяет введенные координаты на правильность
    # а затем парсит их в числовые координаты для матрицы игрового поля (x,y)
    def user_input
        puts "Enter the coordinates of the ship:"
        cord = gets.chomp.downcase

        # цикл проверка введенных координат
        # прерывается только тогда, когда пользователь введет
        # корректные кординаты или же сдастся
        loop do
            retCode = chek_user_input?(cord)
            if retCode && retCode != nil
                break
            elsif retCode == nil
                return nil
            end
            puts "Incorrect coordinate!"
            puts "\nEnter the coordinates of the ship:"
            cord = gets.chomp.downcase
        end

        # парсинг координат, введеных пользователем
        # получение двух значений: буквенного и цифрового
        # и запись их в переменные cordY - буквенная и cordX - численная
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

        # парсинг буквенного значения
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

    # функция начала игры
    # инициализация рандобный кораблей в поле
    # затем цикл игр, который прерывается, если игрок выиграл
    # или ввел "surrender"
    def start_game
        init_ships_on_field()

        loop do
            puts `clear` # очистка консоли

            print_fields()
            puts

            inputCords = user_input()

            # проверка, сдался ли игрок
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

trap("INT") {puts "\nBye!"; exit} # отлавливание выхода

g = Game.new # создание экземпляра класса Game
g.start_game # запуск игры