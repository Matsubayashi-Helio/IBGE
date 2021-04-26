require 'spec_helper'
require 'city_name'
require 'faraday'
require 'byebug'


describe CityName do
    context 'Fetch API Data' do
        it 'should get all cities' do
            path = File.expand_path("support/get_cities.json","#{File.dirname(__FILE__)}/..") 
            json = File.read(path)
            response = double('faraday_response', body: json, status: 200)
            allow(Faraday).to receive(:get)
                        .with('https://servicodados.ibge.gov.br/api/v1/localidades/municipios?orderBy=nome')
                        .and_return(response)
            
            cities = CityName.cities

            expect(cities.first.city).to eq 'Abadia de Goiás'
            expect(cities.first.initials).to eq 'GO'
            expect(cities.first.state).to eq 'Goiás'
        end
        
        it 'should return empty if cannot return data' do
            response = double('faraday_response', body: '', status: 400)
            allow(Faraday).to receive(:get)
                        .with('https://servicodados.ibge.gov.br/api/v1/localidades/municipios?orderBy=nome')
                        .and_return(response)
            
            cities = CityName.cities

            expect(cities.length).to eq 0
        end
    end
end