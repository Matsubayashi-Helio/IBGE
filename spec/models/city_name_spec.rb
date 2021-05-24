# frozen_string_literal: true

require 'test_helper'
require 'city_name'
require 'faraday'
require 'byebug'

describe CityName do
  stub_const('IBGE_LOCATION_API', 'https://servicodados.ibge.gov.br/api/v1/localidades/municipios?orderBy=nome')

  context 'Fetch API Data' do
    it 'should get all cities' do
      path = File.expand_path('support/get_cities.json', "#{File.dirname(__FILE__)}/..")
      json = File.read(path)
      response = double('faraday_response', body: json, status: 200)
      allow(Faraday).to receive(:get)
        .with(IBGE_LOCATION_API)
        .and_return(response)

      cities = CityName.cities

      expect(cities.first.name).to eq 'Abadia de Goiás'
      expect(cities.first.uf).to eq 'GO'
      expect(cities.first.location_id).to eq 5_200_050
    end

    it 'should return empty if cannot return data' do
      response = double('faraday_response', body: '', status: 400)
      allow(Faraday).to receive(:get)
        .with(IBGE_LOCATION_API)
        .and_return(response)

      cities = CityName.cities

      expect(cities.length).to eq 0
    end
  end
end
