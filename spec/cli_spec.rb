# require 'spec_helper'
require 'cli'
require 'faraday'
require 'name'
require 'byebug'
require 'json'
require 'stringio'
require 'test_helper'



describe Cli do

    before(:all) do
        IBGE_NAMES_API = "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=".freeze
        IGBE_NAMES_API_FREQUENCY = "https://servicodados.ibge.gov.br/api/v2/censos/nomes/".freeze
    end

    context 'User input' do
        it '.user_input_uf' do
            io = StringIO.new
            io.puts 'SP'
            io.rewind
            $stdin = io

            input_uf = Cli.user_input_uf
            expect(input_uf).to eq 'SP'

            $stdin = STDIN
        end
        
        it '.get_city_name' do
            io = StringIO.new
            io.puts 'são paulo'
            io.rewind
            $stdin = io

            input_uf = Cli.user_input_uf
            expect(input_uf).to eq 'são paulo'
            
            $stdin = STDIN
        end

        it '.get_names' do
            io = StringIO.new
            io.puts 'joao, maria'
            io.rewind
            $stdin = io

            path = File.expand_path("support/get_names_frequency.json","#{File.dirname(__FILE__)}") 
            json = File.read(path)
            response = double('faraday_response', body: json, status: 200)
            api_path = IGBE_NAMES_API_FREQUENCY + "joao%7Cmaria"
            allow(Faraday).to receive(:get).with(api_path).and_return(response)
            
            names = Cli.get_names
            expect(names.first[:nome]).to eq 'JOAO'
            expect(names.first[:res].first[:periodo]).to eq '1930['
            expect(names.first[:res].first[:frequencia]).to eq 60155
            expect(names.first[:res].last[:periodo]).to eq '[2000,2010['
            expect(names.first[:res].last[:frequencia]).to eq 794118
            expect(names.last[:nome]).to eq 'MARIA'
            expect(names.last[:res].first[:periodo]).to eq '1930['
            expect(names.last[:res].first[:frequencia]).to eq 336477
            expect(names.last[:res].last[:periodo]).to eq '[2000,2010['
            expect(names.last[:res].last[:frequencia]).to eq 1111301

            $stdin = STDIN
        end
    end

    context 'show tables for the user' do
        context '.show_names_by_uf' do
            it 'return false if nothing goes wrong' do
                rj = create(:state, uf:'RJ')

                allow(Name).to receive(:rank_by_location).and_return([])
                uf = Cli.show_names_by_uf('RJ')
            
                expect(uf).to eq false
            end

            it 'return true if uf do not exist' do
                uf = Cli.show_names_by_uf('RJ')
                expect(uf).to eq true
            end
        end

        context '.show_names_by_city' do
            it 'return false if nothing goes wrong' do
                uf_rj = create(:state)
                city_rj = create(:city, name:'Rio de Janeiro', state: uf_rj)

                allow(Name).to receive(:rank_by_location).and_return([])
                city = Cli.show_names_by_city('Rio de Janeiro')

                expect(city).to eq false
            end

            it 'return true if city do not exist' do
                city = Cli.show_names_by_city('Paris')
                expect(city).to eq true
            end

            it 'show names frequency by decade' do
                path = File.expand_path("support/get_names_frequency.json","#{File.dirname(__FILE__)}") 
                json = File.read(path)
                response = double('faraday_response', body: json, status: 200)
                allow(Faraday).to receive(:get).with("https://servicodados.ibge.gov.br/api/v2/censos/nomes/joao%7Cmaria").and_return(response)
                
                names_joao_and_maria = JSON.parse(json, symbolize_names: true)

                expect{Cli.show_names_frequency(names_joao_and_maria)}.to output(
                                                include("| PERÍODO     | JOAO        | MARIA      |",
                                                        "|   < 1930    |    60155    |   336477   |",
                                                        "|    2000     |   794118    |  1111301   |")).to_stdout
            end
        end

        context '.show_table' do
            it 'shows table with rank of the most common names for uf' do
                rj = create(:state, location_id: 33)

                path = File.expand_path("support/get_names_by_uf.json","#{File.dirname(__FILE__)}") 
                json = File.read(path)
                response = double('faraday_response', body: json, status: 200)
                api_path = IBGE_NAMES_API + "#{rj.location_id}"
                allow(Faraday).to receive(:get).with(api_path).and_return(response)

                expect{Cli.show_table(rj)}.to output(include("| RANK | NOME     | FREQUENCIA | % RELATIVA |",
                                                            "| 1    | MARIA    | 752021     | 4.356      |",
                                                            "| 20   | RODRIGO  | 70436      | 0.408      |")).to_stdout
            end

            it 'shows table with rank of the most common female names for uf' do
                rj = create(:state, location_id: 33)

                path_f = File.expand_path("support/get_names_by_uf_and_gender_F.json","#{File.dirname(__FILE__)}") 
                json_f = File.read(path_f)
                response_f = double('faraday_response', body: json_f, status: 200)
                api_path_f = IBGE_NAMES_API + "#{rj.location_id}&sexo=F"
                allow(Faraday).to receive(:get).with(api_path_f).and_return(response_f)

                expect{Cli.show_table(rj, 'F')}.to output(include("| NOMES MAIS COMUNS DE RIO DE JANEIRO (FEMININO) |",
                                                                "| 1         | MARIA    | 749527     | 4.342      |",
                                                                "| 20        | LETICIA  | 40526      | 0.235      |")).to_stdout
            end

            it 'shows table with rank of the most common male names for uf' do
                rj = create(:state, location_id: 33)

                path_m = File.expand_path("support/get_names_by_uf_and_gender_M.json","#{File.dirname(__FILE__)}") 
                json_m = File.read(path_m)
                response_m = double('faraday_response', body: json_m, status: 200)
                api_path_m = IBGE_NAMES_API + "#{rj.location_id}&sexo=M"
                allow(Faraday).to receive(:get).with(api_path_m).and_return(response_m)

                expect{Cli.show_table(rj, 'M')}.to output(include("| NOMES MAIS COMUNS DE RIO DE JANEIRO (MASCULINO) |",
                                                                "| 1         | JOSE      | 312855     | 1.813      |",
                                                                "| 20        | FELIPE    | 67505      | 0.391      |")).to_stdout
            end

            it 'shows table with rank of the most common names for city' do
                uf_rj = create(:state)
                city_rj = create(:city, name:'Rio de Janeiro', location_id: 3304557, population_2019: 6718903, state: uf_rj)

                path = File.expand_path("support/get_names_by_city.json","#{File.dirname(__FILE__)}") 
                json = File.read(path)
                response = double('faraday_response', body: json, status: 200)
                api_path = IBGE_NAMES_API + "#{city_rj.location_id}"
                allow(Faraday).to receive(:get).with(api_path).and_return(response)

                expect{Cli.show_table(city_rj)}.to output(include("| RANK | NOME      | FREQUENCIA | % RELATIVA |", 
                                                                "| 1    | MARIA     | 307018     | 4.57       |",
                                                                "| 3    | JOSE      | 118239     | 1.76       |",
                                                                "| 20   | ANDRE     | 30387      | 0.453      |")).to_stdout
            end

            it 'shows table with rank of the most common female names for city' do
                uf_rj = create(:state)
                city_rj = create(:city, name:'Rio de Janeiro', location_id: 3304557, population_2019: 6718903, state: uf_rj)

                path_f = File.expand_path("support/get_names_by_city_and_gender_F.json","#{File.dirname(__FILE__)}") 
                json_f = File.read(path_f)
                response_f = double('faraday_response', body: json_f, status: 200)
                api_path_f = IBGE_NAMES_API + "#{city_rj.location_id}&sexo=F"
                allow(Faraday).to receive(:get).with(api_path_f).and_return(response_f)

                expect{Cli.show_table(city_rj, 'F')}.to output(include("| NOMES MAIS COMUNS DE RIO DE JANEIRO (FEMININO) |",
                                                                    "| RANK      | NOME     | FREQUENCIA | % RELATIVA |", 
                                                                    "| 1         | MARIA    | 305973     | 4.554      |",
                                                                    "| 20        | LUCIA    | 16596      | 0.248      |")).to_stdout
            end

            it 'shows table with rank of the most common female names for city' do
                uf_rj = create(:state)
                city_rj = create(:city, name:'Rio de Janeiro', location_id: 3304557, population_2019: 6718903, state: uf_rj)

                path_m = File.expand_path("support/get_names_by_city_and_gender_M.json","#{File.dirname(__FILE__)}") 
                json_m = File.read(path_m)
                response_m = double('faraday_response', body: json_m, status: 200)
                api_path_m = IBGE_NAMES_API + "#{city_rj.location_id}&sexo=M"
                allow(Faraday).to receive(:get).with(api_path_m).and_return(response_m)

                expect{Cli.show_table(city_rj, 'M')}.to output(include("| NOMES MAIS COMUNS DE RIO DE JANEIRO (MASCULINO) |",
                                                                    "| RANK      | NOME      | FREQUENCIA | % RELATIVA |", 
                                                                    "| 1         | JOSE      | 117746     | 1.753      |",
                                                                    "| 20        | FELIPE    | 29093      | 0.434      |")).to_stdout
            end
        end

        it '.show_names_frequency' do
            path = File.expand_path("support/get_names_frequency.json","#{File.dirname(__FILE__)}") 
            json = File.read(path)
            response = double('faraday_response', body: json, status: 200)
            api_path = IGBE_NAMES_API_FREQUENCY + "joao%7Cmaria"
            allow(Faraday).to receive(:get).with(api_path).and_return(response)
            
            names = 'joao, maria'
            api_names = Name.names_frequency(names)

            expect{Cli.show_names_frequency(api_names)}.to output(include("| FREQUÊNCIA DE NOME POR DÉCADA ATÉ 2010 |",
            "| PERÍODO     | JOAO        | MARIA      |", 
            "|   < 1930    |    60155    |   336477   |",
            "|    2000     |   794118    |  1111301   |")).to_stdout
        end

        it '.show_ufs' do
            State.create(name: 'Acre', uf: 'AC', location_id: 12, population_2019: 881935)
            State.create(name: 'Tocantins', uf: 'TO', location_id: 17, population_2019: 1572866)

            expect {Cli.show_ufs}.to output(include("UF | ESTADO", "AC | Acre", "TO | Tocantins")).to_stdout
        end
    end
end


