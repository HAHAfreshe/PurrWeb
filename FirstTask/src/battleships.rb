# Основной класс игры
class Game
  def initialize
    @board = Array.new(10) { Array.new(10, '.').clone }
    @ships = [0, 4, 3, 2, 1]
    @str_cords = { 'a' => 0, 'b' => 1, 'c' => 2, 'd' => 3, 'e' => 4, 'f' => 5, 'g' => 6, 'h' => 7, 'i' => 8, 'j' => 9 }
    @surrend = false
  end

  # очистка игрового поля
  def clear_field
    @board.each do |i|
      i.each do |j|
        @board[i][j] = '.'
      end
    end

    return_ships
  end

  # возвращение кораблей в док
  def return_ships
    @ships = [0, 4, 3, 2, 1]
  end

  # функция проверки установки палубы
  # проверяет саму клетку и клетки вокруг на возможность установить палубу
  # создает 2 массива с координатами по x и по y
  # затем проверяем возможность установить палубу
  def dock_can_input?(cord_x, cord_y)
    if cord_x >= 0 && cord_x <= 9 && cord_y >= 0 && cord_y <= 9
      tmp_arr_x = Array.new(9)
      tmp_arr_y = Array.new(9)

      tmp_arr_x[0] = cord_x + 1
      tmp_arr_y[0] = cord_y + 1

      tmp_arr_x[1] = cord_x
      tmp_arr_y[1] = cord_y + 1

      tmp_arr_x[2] = cord_x - 1
      tmp_arr_y[2] = cord_y + 1

      tmp_arr_x[3] = cord_x + 1
      tmp_arr_y[3] = cord_y

      tmp_arr_x[4] = cord_x
      tmp_arr_y[4] = cord_y

      tmp_arr_x[5] = cord_x - 1
      tmp_arr_y[5] = cord_y

      tmp_arr_x[6] = cord_x + 1
      tmp_arr_y[6] = cord_y - 1

      tmp_arr_x[7] = cord_x
      tmp_arr_y[7] = cord_y - 1

      tmp_arr_x[8] = cord_x - 1
      tmp_arr_y[8] = cord_y - 1

      (0..8).each do |i|
        next unless tmp_arr_x[i] > -1 && tmp_arr_y[i] > -1 && tmp_arr_x[i] < 10 && tmp_arr_y[i] < 10
        if @board[tmp_arr_x[i]][tmp_arr_y[i]] == 'S'
          return false
        end
      end
      return true
    end
    false
  end

  # функция проверки установки корабля в зависимости от направления
  # запускаем цикл с кол-вом палуб корабля (type-1)
  # и пробуем поставить следующую за палубу
  # если получилось установитьь все палубы - возвращяем массив координат этих палуб
  def testing_input_direct_ship(x, y, dir_x, dir_y, type)
    cords_arr = Array.new(type) { Array.new(2).clone }

    (0..type - 1).each do |i|
      return nil unless dock_can_input?(x, y)

      cords_arr[i][0] = x
      cords_arr[i][1] = y
      x += dir_x
      y += dir_y
    end
    cords_arr
  end

  # функция проверки установки корабля по данным координатам
  # проверяет, возможно ли поставить палубу корабля
  # затем в зависимости от направления получает полные кординаты корабля из функции testing_input_direct_ship
  def testing_input_ship(x, y, dir, type)
    cords_arr = Array.new(type) { Array.new(2).clone }

    if dock_can_input?(x, y)
      case dir
      when 0
        # попытка поставить корабль "вниз" по координате x
        cords_arr = testing_input_direct_ship(x, y, 1, 0, type)
        # если не получилось поставить "вниз", пробуем поставить "вверх"
        cords_arr = testing_input_direct_ship(x, y, -1, 0, type) if cords_arr.nil?
      when 1
        # попытка поставить корабль "вправо" по координате x
        cords_arr = testing_input_direct_ship(x, y, 0, 1, type)
        # если не получилось поставить "вправо", пробуем поставить "влево"
        cords_arr = testing_input_direct_ship(x, y, 0, -1, type) if cords_arr.nil?
      end
      # возвращяем массив координат
      return cords_arr
    end
    nil
  end

  # функция попытки установки корабля на поля
  # получает массив координат, куда нужно установить корабль из функции testing_input_ship
  # затем, если массив не пустой - ставит корабль
  def ship_can_insert?(cord_x, cord_y, dir, type)
    cord_ship = testing_input_ship(cord_x, cord_y, dir, type)

    unless cord_ship.nil?
      cord_ship.each do |i|
        @board[i[0]][i[1]] = 'S'
      end
      return true
    end
    false
  end

  # функция создания рандомных кораблей на поле
  # startShip - с какого типа корабля нужно начинать
  # записывает рандомные координаты (от 0 до 9) и рандомное направление
  # 0 - по горизонтали
  # 1 - по вертикали
  # затем пробует поставить корабль, и если все хорошо - отнимает кол-во
  # данного типа коробля из массива кораблей
  def init_ships_on_field
    start_ship = 4

    while @ships.sum.positive?
      cord_x = rand(10)
      cord_y = rand(10)
      direct = rand(2)

      next unless ship_can_insert?(cord_x, cord_y, direct, start_ship)

      @ships[start_ship] -= 1
      start_ship -= 1 if @ships[start_ship].zero?
    end
  end

  # функция вывода игрового поля
  # перебирает массив и создает строку, которую должен вывести
  # также проверяет, сдался ли пользователь, чтоб вывести
  # игровое поле с отображение кораблей/промахов и попаданий
  def print_field
    puts '   A B C D E F G H I J'
    iter = 0
    @board.each do |row|
      string = ''
      row.each do |v|
        string +=
          if !@surrend && (v.include?('S') || v.include?('.'))
            ' .'
          else
            " #{v}"
          end
      end

      iter += 1

      string = iter < 10 ? "#{iter} #{string}" : "#{iter}#{string}"

      puts string
    end
  end

  # функция выстрела
  # в зависимости от попадания или промаха
  # вносит нужное значение в матрицу поля
  def shooting(cord_x, cord_y)
    @board[cord_x][cord_y] =
      case @board[cord_x][cord_y]
      when 'S'
        'x'
      else
        'o'
      end
  end

  # функция проверки окончания игры
  # перебирает массив и проверяет на наличие кораблей
  def game_is_finish?
    @board.each do |i|
      if i.include?('S')
        return false
      end
    end
    true
  end

  #  функция проверки ввода
  # принимает в качестве аргумента координату, введеную пользователем
  # если она соответсвует регулярному выражению или же
  # пользователь ввел "surrender", то возврощяем true/nil
  def input_is_correct?(cord)
    cord = cord.gsub(' ', '')
    if cord == 'surrender'
      puts `clear`
      puts 'What a shame…'
      puts
      @surrend = true
      print_field
      return nil
    end

    if cord.match(/^[a-jA-J][1-9]0*$/)
      case cord.length
      when 2
        return true
      when 3
        if cord[1].to_i == 1
          return true
        end
      end
    end
    false
  end

  # функция ввода пользователя
  # Проверяет введенные координаты на правильность
  # а затем парсит их в числовые координаты для матрицы игрового поля (x,y)
  def user_input
    puts 'Enter the coordinates of the ship:'
    cord = gets.chomp.downcase

    # цикл проверка введенных координат
    # прерывается только тогда, когда пользователь введет
    # корректные кординаты или же сдастся
    loop do
      ret_code = input_is_correct?(cord)
      break if ret_code && !ret_code.nil?

      if ret_code.nil?
        return nil
      end

      puts 'Incorrect coordinate!'
      puts "\nEnter the coordinates of the ship:"
      cord = gets.chomp.downcase
    end

    # парсинг координат, введеных пользователем
    # получение двух значений: буквенного и цифрового
    # и запись их в переменные cordY - буквенная и cordX - численная
    case cord.length
    when 2
      cord_y = cord[0]
      cord_x = cord[1].to_i - 1
    when 3
      if cord[1].to_i == 1
        cord_y = cord[0]
        cord_x = "#{cord[1]}#{cord[2]}".to_i - 1
      end
    end

    # парсинг буквенного значения
    cord_y = @str_cords[cord_y]

    [cord_x.to_i, cord_y.to_i]
  end

  # функция начала игры
  # инициализация рандобный кораблей в поле
  # затем цикл игр, который прерывается, если игрок выиграл
  # или ввел "surrender"
  def start_game
    init_ships_on_field
    loop do
      puts `clear`
      print_field
      puts

      input_cords = user_input

      # проверка, сдался ли игрок
      break if input_cords.nil?

      shooting(input_cords[0], input_cords[1])

      if game_is_finish?
        puts 'You win!'
        break
      end
    end
  end
end

trap('INT') { puts "\nBye!"; exit } # отлавливание выхода

g = Game.new # создание экземпляра класса Game
g.start_game # запуск игры
