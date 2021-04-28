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

        context 'ranking by gender' do
            it 'should get woman names' do
                path = File.expand_path("support/get_names_by_gender_F.json","#{File.dirname(__FILE__)}/..") 
                json = File.read(path)
                response = double('faraday_response', body: json, status: 200)
                allow(Faraday).to receive(:get).with("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?sexo=F").and_return(response)

                names_gender_f = Name.rank_by_gender('F')

                expect(names_gender_f.first[:nome]).to eq('MARIA')
                expect(names_gender_f.first[:frequencia]).to eq 11694738
                expect(names_gender_f.first[:ranking]).to eq 1
                expect(names_gender_f.last[:nome]).to eq('MARIANA')
                expect(names_gender_f.last[:frequencia]).to eq 381778
                expect(names_gender_f.last[:ranking]).to eq 20
            end

            it 'should get man names' do
                path = File.expand_path("support/get_names_by_gender_M.json","#{File.dirname(__FILE__)}/..") 
                json = File.read(path)
                response = double('faraday_response', body: json, status: 200)
                allow(Faraday).to receive(:get).with("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?sexo=M").and_return(response)

                names_gender_m = Name.rank_by_gender('M')

                expect(names_gender_m.first[:nome]).to eq('JOSE')
                expect(names_gender_m.first[:frequencia]).to eq 5732508
                expect(names_gender_m.first[:ranking]).to eq 1
                expect(names_gender_m.last[:nome]).to eq('RODRIGO')
                expect(names_gender_m.last[:frequencia]).to eq 598825
                expect(names_gender_m.last[:ranking]).to eq 20
            end

            it 'should return empty if cannot get data' do
                response = double('faraday_response', body: '', status: 400)
                allow(Faraday).to receive(:get).with("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?sexo=F").and_return(response)

                names_gender_f = Name.rank_by_gender('F')


                expect(names_gender_f.length).to eq 0
            end
        end
    end
end