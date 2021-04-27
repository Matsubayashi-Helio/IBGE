state_table = []
states = StateName.states
states.each do |s|
    state_table << State.new(state: s.state, uf: s.uf)
end
State.import state_table, validate: true

city_table = []
cities = CityName.cities
cities.each do |c|
    state = State.find_by(uf: c.uf)
    city_table << City.new(city: c.city, state: state )
end
City.import city_table, validate: true