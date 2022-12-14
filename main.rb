class Station
  attr_reader :name, :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  # Может принимать поезда (по одному за раз)
  def get_train(train)
    self.trains.push(train)
    #@trains << train
    puts "На станцию #{name} прибыл поезд № #{train.number}"
  end

  # Может возвращать список всех поездов на станции, находящиеся в текущий момент
  def trains_in_station
    puts "На станции #{name} в данный момент находятся след поезда:"
    trains.each { |train| puts " #{train.number} - #{train.type} - #{train.wagon_count}" }
  end

  # Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  def trains_type_in_station(type)
    puts "Поезда на станции #{name} типа #{type}: "
    trains.select { |train| train.type == type }
  end

  # Метод отдающий кол-во по типу
  def count_trains_by(type)
    trains.count { |x| x.type == type }
  end

  # Может отправлять поезда(по одному за раз, поезда удаляются из списка)
  def send_train(train)
    @trains.delete(train)
    puts "Из станции #{name} отправляется поезд с номером № #{train.number}"
  end
end

class Route
  attr_reader :stations, :from, :to

  def initialize(from, to)
    @from = from
    @to = to
    @stations = [@from, @to]
  end

  # Может добавлять промежуточную станцию в список
  def add_station(station)
    stations.insert(1, station)
  end

  # Может удалять промежуточную станцию из списка
  def delete_station(station)
    if stations[0] == station || stations[stations.length - 1] == station
      puts 'Первую и последную станцию нельзя удалять!'
    else
      puts "Удалена станция #{station.name}"
      stations.delete(station)
      puts "Все станции на маршруте #{stations.first.name} - #{stations.last.name}"
      stations.each { |st| puts st.name }
    end
  end

  # Может выводить список всех станций по-порядку от начальной до конечной
  def show_stations
    puts "В маршрут #{stations.first.name} - #{stations.last.name} входят станции: "
    stations.each { |station| puts "#{station.name}" }
  end
end

class Train
  attr_reader :speed, :wagon_count, :number

  def initialize(number, type, wagon_count)
    @number = number
    @type = type
    @wagon_count = wagon_count
    @speed = 0
    @route = nil
    @station_index = nil
  end

  # Может тормозить (сбрасывать скорость до нуля)
  def stop
    @speed = 0
  end

  # Может прицеплять вагоны
  def add_wagon
    if speed.zero?
      @wagon_count += 1
      puts "К поезду № #{number} прицепили вагон. Теперь их #{wagon_count}."
    else
      puts 'На ходу нельзя прицеплять вагоны!'
    end
  end

  # Может отцеплять вагоны
  def remove_wagon
    if wagon_count.zero?
      puts 'Вагонов уже не осталось.'
    elsif speed.zero?
      @wagon_count -= 1
      puts "От поезда №#{number} отцепили вагон. Теперь их #{wagon_count}."
    else
      puts 'На ходу нельзя отцеплять вагоны!'
    end
  end

  # Может принимать маршрут следования (объект класса Route).
  def take_route(route)
    @route = route
    @station_index = 0
    current_station.get_train(self)
    puts "Поезду № #{number} задан маршрут #{route.stations.first.name} - #{route.stations.last.name}"
  end

  # Текущая станция
  def current_station
    @route.stations[@station_index]
  end

  # Следующая станция
  def next_station
    @route.stations[@station_index + 1]
  end

  # Предедущая станция
  def prev_station
    @route.stations[@station_index - 1]
  end

  # Вперед
  def move_to_next_station
    current_station.send_train(self)
    @station_index += 1
    current_station.get_train(self)
  end

  # Назад
  def move_to_prev_station
    current_station.send_train(self)
    @station_index -= 1
    current_station.get_train(self)
  end
end

tr1 = Train.new(1254, 'pas', 15)
tr2 = Train.new(2520, 'gruz', 30)
tr3 = Train.new(1375, 'pas', 13)
tr4 = Train.new(4949, 'pas', 18)
tr5 = Train.new(7988, 'gruz', 15)

st1 = Station.new('Latugino')
st2 = Station.new('Novokosino')
st3 = Station.new('Aviamatornya')
st4 = Station.new('Kaluzhskaya')
st5 = Station.new('Dinamo')

rt1 = Route.new(st1, st2)
rt1.add_station(st3)
rt1.add_station(st4)
rt1.add_station(st5)

tr1.take_route(rt1)

tr1.move_to_next_station
tr1.move_to_next_station
tr1.move_to_next_station
tr1.move_to_next_station

tr1.move_to_prev_station
