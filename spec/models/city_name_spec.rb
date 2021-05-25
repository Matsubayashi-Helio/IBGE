# frozen_string_literal: true

require 'test_helper'
require 'city_name'
require 'faraday'
require 'byebug'

describe CityName do
  context 'Fetch API Data' do
    it 'should get all cities' do
      path = File.expand_path('support/get_cities.json', "#{File.dirname(__FILE__)}/..")
      json = File.read(path)
      api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/../.."))

      path_api = api['test']['base'] + api['test']['city']
      response = double('faraday_response', body: json, status: 200)
      allow(Faraday).to receive(:get)
        .with(path_api)
        .and_return(response)

      cities = CityName.cities
      expect(cities.first.name).to eq 'Abadia de Goiás'
      expect(cities.first.uf).to eq 'GO'
      expect(cities.first.location_id).to eq 5_200_050
    end

    it 'should return empty if cannot return data' do
      api = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/../.."))
      path_api = api['test']['base'] + api['test']['city']
      response = double('faraday_response', body: '', status: 400)
      allow(Faraday).to receive(:get)
        .with(path_api)
        .and_return(response)

      cities = CityName.cities

      expect(cities.length).to eq 0
    end
  end
end
