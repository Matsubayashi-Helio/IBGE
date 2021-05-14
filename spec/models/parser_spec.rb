require 'test_helper'
require'parser'
require 'byebug'

describe Parser do

    before(:all) do
        IBGE_NAMES_API = "https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=".freeze
        IGBE_NAMES_API_FREQUENCY = "https://servicodados.ibge.gov.br/api/v2/censos/nomes/".freeze
    end

    context '.parse' do
        context '--uf [UF]' do
            it 'should show table if [UF] is informed' do
                rj = State.create(name: 'Rio de Janeiro', uf: 'RJ', location_id: 33, population_2019: 17264943)
                allow(Name).to receive(:rank_by_location).and_return([])
                
                option = "--uf=RJ"
                expect{Parser.parse %W[#{option}]}.to output(include("|  NOMES MAIS COMUNS DE RIO DE JANEIRO  |",
                                                            "| NOMES MAIS COMUNS DE RIO DE JANEIRO (FEMININO) |",
                                                            "| NOMES MAIS COMUNS DE RIO DE JANEIRO (MASCULINO) |")).to_stdout
            end

            it 'should show list of uf if [UF] is not informed' do
                State.create(name: 'Acre', uf: 'AC', location_id: 12, population_2019: 881935)
                State.create(name: 'Tocantins', uf: 'TO', location_id: 17, population_2019: 1572866)
                io = StringIO.new
                io.puts 'AC'
                io.rewind
                $stdin = io
                allow(Name).to receive(:rank_by_location).and_return([])
                
                option = "--uf"
                expect{Parser.parse %W[#{option}]}.to output(include("UF | ESTADO", "AC | Acre", "TO | Tocantins")).to_stdout
                $stdin = STDIN
            end

            it 'should show a message if [UF] does not exist and ask to input a valid UF' do
                rj = State.create(name: 'Rio de Janeiro', uf: 'RJ', location_id: 33, population_2019: 17264943)

                io = StringIO.new
                io.puts 'RJ'
                io.rewind
                $stdin = io
                allow(Name).to receive(:rank_by_location).and_return([])
                option = "--uf=SP"
                expect{Parser.parse %W[#{option}]}.to output(include("UF inválida, digite novamente",
                                                        "|  NOMES MAIS COMUNS DE RIO DE JANEIRO  |",
                                                        "| NOMES MAIS COMUNS DE RIO DE JANEIRO (FEMININO) |",
                                                        "| NOMES MAIS COMUNS DE RIO DE JANEIRO (MASCULINO) |")).to_stdout
                $stdin = STDIN
            end
        end

        context '-u [UF]' do
            it 'should show table if [UF] is informed' do
                rj = State.create(name: 'Rio de Janeiro', uf: 'RJ', location_id: 33, population_2019: 17264943)

                allow(Name).to receive(:rank_by_location).and_return([])
                option = "-u RJ"
                expect{Parser.parse %W[#{option}]}.to output(include("|  NOMES MAIS COMUNS DE RIO DE JANEIRO  |",
                                                            "| NOMES MAIS COMUNS DE RIO DE JANEIRO (FEMININO) |",
                                                            "| NOMES MAIS COMUNS DE RIO DE JANEIRO (MASCULINO) |")).to_stdout
            end

            it 'should show list of uf if [UF] is not informed' do
                State.create(name: 'Acre', uf: 'AC', location_id: 12, population_2019: 881935)
                State.create(name: 'Tocantins', uf: 'TO', location_id: 17, population_2019: 1572866)

                io = StringIO.new
                io.puts 'AC'
                io.rewind
                $stdin = io
                allow(Name).to receive(:rank_by_location).and_return([])
                option = "-u"
                expect{Parser.parse %W[#{option}]}.to output(include("UF | ESTADO", "AC | Acre", "TO | Tocantins")).to_stdout
                $stdin = STDIN
            end

            it 'should show a message if [UF] does not exist and ask to input a valid UF' do
                rj = State.create(name: 'Rio de Janeiro', uf: 'RJ', location_id: 33, population_2019: 17264943)

                io = StringIO.new
                io.puts 'RJ'
                io.rewind
                $stdin = io
                allow(Name).to receive(:rank_by_location).and_return([])
                option = "-u AA"
                expect{Parser.parse %W[#{option}]}.to output(include("UF inválida, digite novamente",
                                                        "|  NOMES MAIS COMUNS DE RIO DE JANEIRO  |",
                                                        "| NOMES MAIS COMUNS DE RIO DE JANEIRO (FEMININO) |",
                                                        "| NOMES MAIS COMUNS DE RIO DE JANEIRO (MASCULINO) |")).to_stdout
                $stdin = STDIN
            end
        end

        context '--cidade CITY' do
            it 'should show table for CITY' do
                sp = State.create(name: 'São Paulo', uf: 'SP', location_id:35, population_2019: 45919049)
                City.create(name: 'Campinas', location_id:3509502, population_2019: 1204073, state: sp)
                
                allow(Name).to receive(:rank_by_location).and_return([])
                
                option = "--cidade=campinas"
                expect{Parser.parse %W[#{option}]}.to output(include("|     NOMES MAIS COMUNS DE CAMPINAS     |",
                "| NOMES MAIS COMUNS DE CAMPINAS (FEMININO) |",
                "| NOMES MAIS COMUNS DE CAMPINAS (MASCULINO) |")).to_stdout
            end
            
            it 'should show table for CITY with more than one word' do
                sp = State.create(name: 'São Paulo', uf: 'SP', location_id:35, population_2019: 45919049)
                City.create(name: 'São Paulo', location_id:3550308, population_2019: 12252023, state: sp)
                allow(Name).to receive(:rank_by_location).and_return([])
                
                option = "--cidade=são paulo"
                expect{Parser.parse %W[#{option}]}.to output(include("|    NOMES MAIS COMUNS DE SÃO PAULO     |",
                "| NOMES MAIS COMUNS DE SÃO PAULO (FEMININO) |",
                "| NOMES MAIS COMUNS DE SÃO PAULO (MASCULINO) |")).to_stdout
            end
            
            it 'should show a message if CITY does not exist and ask to type a valid CITY' do
                sp = State.create(name: 'São Paulo', uf: 'SP', location_id:35, population_2019: 45919049)
                City.create(name: 'Campinas', location_id:3509502, population_2019: 1204073, state: sp)

                io = StringIO.new
                io.puts 'campinas'
                io.rewind
                $stdin = io
                allow(Name).to receive(:rank_by_location).and_return([])
                
                option = "--cidade=asfasdfas"
                expect{Parser.parse %W[#{option}]}.to output(include("Cidade não encontrada, vefirique acentuação.",
                                                                        "|     NOMES MAIS COMUNS DE CAMPINAS     |",
                                                                        "| NOMES MAIS COMUNS DE CAMPINAS (FEMININO) |",
                                                                        "| NOMES MAIS COMUNS DE CAMPINAS (MASCULINO) |")).to_stdout
                $stdin = STDIN
            end
        end

        context '-c CITY' do
            it 'should show table for CITY' do
                sp = State.create(name: 'São Paulo', uf: 'SP', location_id:35, population_2019: 45919049)
                City.create(name: 'Campinas', location_id:3509502, population_2019: 1204073, state: sp)

                allow(Name).to receive(:rank_by_location).and_return([])
                
                option = "-c campinas"
                expect{Parser.parse %W[#{option}]}.to output(include("|     NOMES MAIS COMUNS DE CAMPINAS     |",
                                                            "| NOMES MAIS COMUNS DE CAMPINAS (FEMININO) |",
                                                            "| NOMES MAIS COMUNS DE CAMPINAS (MASCULINO) |")).to_stdout
            end

            it 'should show table for CITY with more than one word' do
                sp = State.create(name: 'São Paulo', uf: 'SP', location_id:35, population_2019: 45919049)
                City.create(name: 'São Paulo', location_id:3550308, population_2019: 12252023, state: sp)

                allow(Name).to receive(:rank_by_location).and_return([])
                
                option = "-c são paulo"
                expect{Parser.parse %W[#{option}]}.to output(include("|    NOMES MAIS COMUNS DE SÃO PAULO     |",
                                                            "| NOMES MAIS COMUNS DE SÃO PAULO (FEMININO) |",
                                                            "| NOMES MAIS COMUNS DE SÃO PAULO (MASCULINO) |")).to_stdout
            end

            it 'should show a message if CITY does not exist and ask to type a valid CITY' do
                sp = State.create(name: 'São Paulo', uf: 'SP', location_id:35, population_2019: 45919049)
                City.create(name: 'Campinas', location_id:3509502, population_2019: 1204073, state: sp)

                io = StringIO.new
                io.puts 'campinas'
                io.rewind
                $stdin = io
                allow(Name).to receive(:rank_by_location).and_return([])
                option = "-c asfasdfas"
                expect{Parser.parse %W[#{option}]}.to output(include("Cidade não encontrada, vefirique acentuação.",
                                                                        "|     NOMES MAIS COMUNS DE CAMPINAS     |",
                                                                        "| NOMES MAIS COMUNS DE CAMPINAS (FEMININO) |",
                                                                        "| NOMES MAIS COMUNS DE CAMPINAS (MASCULINO) |")).to_stdout
                $stdin = STDIN
            end
        end
        
        
        context 'show tips command' do
            it '-d' do
                option = "-d"
                expect{Parser.parse %W[#{option}]}.to output(include("Algumas dicas para a consulta de nomes ou localidades:",
                "---> Nomes compostos não foram considerados.",
                "---> Verifique se cidade/estado possui acentos")).to_stdout
            end
            
            it '--dicas' do
                option = "--dicas"
                expect{Parser.parse %W[#{option}]}.to output(include("Algumas dicas para a consulta de nomes ou localidades:",
                "---> Nomes compostos não foram considerados.",
                "---> Verifique se cidade/estado possui acentos")).to_stdout
            end
        end
        
        context 'show help menu' do
            it '-h' do
                option = "-h"
                expect{Parser.parse %W[#{option}]}.to output(
                    include("-u, --uf [UF]                    Nomes mais comuns de UF em três tabelas.",
                    "-c, --cidade=CIDADE              Nomes mais comuns de CIDADE em três tabelas.",
                    "-f, --frequencia=NOMES           Frequência de NOMES ao longo das decadas",
                    "-h, --help                       Exibe todos os comandos")).to_stdout
                end

            it '--help' do
                option = "--help"
                expect{Parser.parse %W[#{option}]}.to output(
                    include("-u, --uf [UF]                    Nomes mais comuns de UF em três tabelas.",
                    "-c, --cidade=CIDADE              Nomes mais comuns de CIDADE em três tabelas.",
                            "-f, --frequencia=NOMES           Frequência de NOMES ao longo das decadas",
                            "-h, --help                       Exibe todos os comandos")).to_stdout
                        end
        end

        context '-f NAMES' do
            it 'should show table for NAMES' do
                path_frequency = File.expand_path("../support/get_names_frequency.json","#{File.dirname(__FILE__)}") 
                json_frequency = File.read(path_frequency)
                response_frequency = double('faraday_response', body: json_frequency, status: 200)
                api_path_frequency = IGBE_NAMES_API_FREQUENCY + "joao%7Cmaria"
                allow(Faraday).to receive(:get).with(api_path_frequency).and_return(response_frequency)
                
                option = "-f joao, maria"
                expect{Parser.parse %W[#{option}]}.to output(include("| FREQUÊNCIA DE NOME POR DÉCADA ATÉ 2010 |",
                                                            "| PERÍODO     | JOAO        | MARIA      |",
                                                            "|   < 1930    |    60155    |   336477   |",
                                                            "|    2000     |   794118    |  1111301   |")).to_stdout
            end
        
            it 'should show a message if could not find NAMES and ask to type again' do               
                path_frequency = File.expand_path("../support/get_names_frequency.json","#{File.dirname(__FILE__)}") 
                json_frequency = File.read(path_frequency)
                response_frequency = double('faraday_response', body: json_frequency, status: 200)
                api_path_frequency = IGBE_NAMES_API_FREQUENCY + "joao%7Cmaria"
                allow(Faraday).to receive(:get).with(api_path_frequency).and_return(response_frequency)
                
                response_frequency_not_found = double('faraday_response', body: [], status: 400)
                api_path_frequency_not_found = IGBE_NAMES_API_FREQUENCY + "nonamefound"
                allow(Faraday).to receive(:get).with(api_path_frequency_not_found).and_return(response_frequency_not_found)
        
                
                io = StringIO.new
                io.puts 'joao, maria'
                io.rewind
                $stdin = io
        
                option = "-f nonamefound"
                expect{Parser.parse %W[#{option}]}.to output(
                    include("Nome não contabilizado pelo IBGE, ou separador dos nomes está incorreto.",
                                                            "| FREQUÊNCIA DE NOME POR DÉCADA ATÉ 2010 |",
                                                            "| PERÍODO     | JOAO        | MARIA      |",
                                                            "|   < 1930    |    60155    |   336477   |",
                                                            "|    2000     |   794118    |  1111301   |")).to_stdout
                $stdin = STDIN
            end
        end
    end
end