require 'byebug'
require_relative '../config/environment'

puts 'Populating states table...'
state_table = []
states = StateName.states
states.each do |s|
    state_table << State.new(state: s.state, uf: s.uf, location_id: s.location_id)
end
State.import state_table, validate: true

puts 'Populating cities table...'
city_table = []
cities = CityName.cities
cities.each do |c|
    state = State.find_by(uf: c.uf)
    city_table << City.new(city: c.city, state: state, location_id: c.location_id )
end
City.import city_table, validate: true


# byebug
puts 'Done'