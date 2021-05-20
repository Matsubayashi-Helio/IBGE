# frozen_string_literal: true

require 'byebug'
require_relative '../config/environment'
require_relative '../lib/csv_file'

csv_path = File.expand_path('populacao_2019.csv', File.dirname(__FILE__).to_s)
csv = CsvFile.import(csv_path)

puts 'Populating states table...'
state_table = []
states = StateName.states
states.each do |s|
  p = csv.find { |i| i['Cód.'].to_i == s.location_id }
  state_table << State.new(name: s.name, uf: s.uf, location_id: s.location_id,
                           population2019: p['População Residente - 2019'])
end
State.import state_table, validate: true

puts 'Populating cities table...'
city_table = []
cities = CityName.cities
cities.each do |c|
  p = csv.find { |i| i['Cód.'].to_i == c.location_id }
  state = State.find_by(uf: c.uf)
  city_table << City.new(name: c.name, state: state, location_id: c.location_id,
                         population2019: p['População Residente - 2019'])
end
City.import city_table, validate: true

puts 'Done'
