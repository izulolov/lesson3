class Station

  attr_reader :name, :trains
  
  def initialize(name)
    @name = name
    @trains = []
    puts "Станция #{name} построена и готова к работе!"
  end

  # Может принимать поезда (по одному за раз)
  def get_train(train)
    @trains << train
    puts "На станцию #{name} прибыл поезд № #{train.number}"
  end

  # Может возвращать список всех поездов на станции, находящиеся в текущий момент
  def return_trains_in_station
    puts "На станции #{name} в данный момент находятся след поезда:"
    trains.each { |train| puts " #{train.number} - #{train.type} - #{train.wagon_count}" }
  end
  
  # Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
  def return_trains_type(type)
  puts "Поезда на станции #{name} типа #{type}: "
  trains.select { |train| puts train.number if train.type == type }
  end

  # Может отправлять поезда(по одному за раз, поезда удаляются из списка)
  def send_train(train)
    puts "Из станции #{name} отправляется поезд с номером № #{train.number}"
    trains.delete(train)
  end
end


class Route

  attr_reader :stations
  
  def initialize(from, to)
    @from = from
    @to = to
    @stations = [from, to]
  end

  # Может добавлять промежуточную станцию в список
  def add_station(station)
    stations.insert(stations.length - 1, station)
    puts "К маршруту #{stations.first.name} - #{stations.last.name} добавлена станция #{station.name}"
    puts "Все станции на маршруте #{stations.first.name} - #{stations.last.name}"
    stations.each { |st| puts st.name }
  end

  # Может удалять промежуточную станцию из списка
  def delete_station(station)
    if stations[0] == station || stations[stations.length - 1] == station
      puts "Первую и последную станцию нельзя удалять!"
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

  attr_accessor :speed, :wagon_count, :route, :station
  attr_reader :number, :type
  def initialize(number, type, wagon_count)
    @number = number
    @type = type
    @wagon_count = wagon_count
    @speed = 0
    puts "Создан поезд № #{number}. Тип: #{type}. Количество вагонов: #{wagon_count}."
  end
  
  # Может тормозить (сбрасывать скорость до нуля)
  def stop
    self.speed = 0
  end
  
  # Может прицеплять вагоны
  def add_wagon
    if speed.zero?
      self.wagon_count += 1
      puts "К поезду № #{number} прицепили вагон. Теперь их #{wagon_count}."
    else 
      puts "На ходу нельзя прицеплять вагоны!"
    end
  end

  # Может отцеплять вагоны
  def remove_wagon
    if wagon_count.zero?
      puts "Вагонов уже не осталось."
    elsif speed.zero?
      self.wagon_count -= 1
      puts "От поезда №#{number} отцепили вагон. Теперь их #{wagon_count}."
    else 
      puts "На ходу нельзя отцеплять вагоны!"
    end
  end
  
  # Может принимать маршрут следования (объект класса Route).
  def take_route(route)
    self.route = route
    puts "Поезду № #{number} задан маршрут #{route.stations.first.name} - #{route.stations.last.name}"
  end

  # Может перемещаться между станциями, указанными в маршруте
  def go_to(station)
    if route.nil?
      puts "Без маршрута поезд заблудится."
    elsif self.station == station
      puts "Поезд №#{self.number} и так на станции #{self.station.name}"
    elsif route.stations.include?(station)
      self.station.send_train(self) if self.station
      self.station = station
      station.get_train(self)
    else
      puts "Станция #{station.name} не входит в маршрут поезда №#{number}"
    end
  end

  # Возвращать предыдущую станцию, текущую, следующую, на основе маршрута
  def around_stations
    if route.nil?
      puts "Маршрут не задан"
    else
      station_index = route.stations.index(station)
      puts "Сейчас поезд на станции #{station.name}."
      puts "Предыдущая станция - #{route.stations[station_index - 1].name}." if station_index != 0
      puts "Следующая - #{route.stations[station_index + 1].name}." if station_index != route.stations.size - 1
    end
  end
end

tr1 = Train.new(1254, 'pas', 15)
tr2 = Train.new(2520, 'gruz', 30)
tr3 = Train.new(1375, 'pas', 13)
tr4 = Train.new(4949, 'pas', 18)
tr5 = Train.new(7988, 'gruz', 15)


st1 = Station.new("Latugino")
st2 = Station.new("Novokosino")
st3 = Station.new("Aviamatornya")
st4 = Station.new("Kaluzhskaya")
st5 = Station.new("Dinamo")

rt1 = Route.new(st1, st2)
rt1.add_station(st3)
rt1.add_station(st4)
rt1.add_station(st5)
rt1.delete_station(st1)

rt1.delete_station(st2)

rt1.delete_station(st3)

rt1.show_stations

tr3.add_wagon
tr3.add_wagon

tr3.remove_wagon

tr2.take_route(rt1)

tr2.go_to(st4)
tr2.around_stations
