require 'spec_helper'
require 'name'
require 'faraday'

describe Name do
    context 'Fetch API Data' do
        context 'ranking of location' do
            it 'should get names' do
                path = File.expand_path("support/get_names_by_location.json","#{File.dirname(__FILE__)}/..") 
                json = File.read(path)
                response = double('faraday_response', body: json, status: 200)
                allow(Faraday).to receive(:get).with("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=33").and_return(response)

                names_location33 = Name.rank_by_location(33)

                expect(names_location33.first[:nome]).to eq('MARIA')
                expect(names_location33.first[:frequencia]).to eq 752021
                expect(names_location33.first[:ranking]).to eq 1
                expect(names_location33.last[:nome]).to eq('RODRIGO')
                expect(names_location33.last[:frequencia]).to eq 70436
                expect(names_location33.last[:ranking]).to eq 20
            end

            it 'should return empty if cannot get data' do
                response = double('faraday_response', body: '', status: 400)
                allow(Faraday).to receive(:get).with("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=33").and_return(response)

                names_location33 = Name.rank_by_location(33)

                expect(names_location33.length).to eq 0
            end
        end

        it 'should get name frequency across the decades' do
            path = File.expand_path("support/get_names_frequency.json","#{File.dirname(__FILE__)}/..") 
            json = File.read(path)
            response = double('faraday_response', body: json, status: 200)
            allow(Faraday).to receive(:get).with("https://servicodados.ibge.gov.br/api/v2/censos/nomes/joao%7Cmaria").and_return(response)

            names_frequency = Name.names_frequency('joao, maria')

            expect(names_frequency.first[:nome]).to eq('JOAO')
            expect(names_frequency.first[:res].first[:periodo]).to eq('1930[')
            expect(names_frequency.first[:res].first[:frequencia]).to eq(60155)
            expect(names_frequency.first[:res].last[:periodo]).to eq('[2000,2010[')
            expect(names_frequency.first[:res].last[:frequencia]).to eq(794118)
            expect(names_frequency.last[:nome]).to eq('MARIA')
        end
    end
end