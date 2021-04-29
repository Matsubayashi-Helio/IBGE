require 'spec_helper'
require 'cli'
require 'faraday'
require 'name'

describe Cli do
    context 'Run application' do
        it 'should show welcome message' do
            expect {Cli.welcome}.to output("Bem vindo! Esta aplicação fornece dados da população brasileira.\n").to_stdout
        end

        it 'should show help list' do
            expect {Cli.help}.to output(include("Ajuda",  
            "NOMES POR UF\t\t:mostrar nomes mais comuns de um estado", 
            "NOMES POR CIDADE\t:mostrar nomes mais comuns de uma cidade",
            "FREQUENCIA\t\t:mostrar a frequencia dos nomes ao longo das décadas",
            "SAIR\t\t\t:encerra a aplicação")).to_stdout
        end

        it 'show list of ufs' do
            allow($stdin).to receive(:gets).and_return('TO')

            expect {Cli.select_uf}.to output(include("UF | ESTADO", "AC | Acre", "TO | Tocantins")).to_stdout
        end

        it 'show rank names for uf' do
            path = File.expand_path("support/get_names_by_location.json","#{File.dirname(__FILE__)}") 
            json = File.read(path)
            response = double('faraday_response', body: json, status: 200)
            allow(Faraday).to receive(:get).with("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=33").and_return(response)

            expect{Cli.show_names_by_uf('RJ')}.to output(include("| RANK | NOME     | FREQUENCIA |", 
                                                                "| 1    | MARIA    | 752021     |",
                                                                "| 20   | RODRIGO  | 70436      |")).to_stdout
        end

        it 'show rank names for city' do
            path = File.expand_path("support/get_names_by_location_city.json","#{File.dirname(__FILE__)}") 
            json = File.read(path)
            response = double('faraday_response', body: json, status: 200)
            allow(Faraday).to receive(:get).with("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=5200050").and_return(response)

            expect{Cli.show_names_by_city('Abadia de Goiás')}.to output(include("| RANK       | NOME       | FREQUENCIA |", 
                                                                "| 1          | MARIA      | 348        |",
                                                                "| 18         | APARECIDA  | 23         |")).to_stdout
        end

        it 'show names frequency by decade' do
            path = File.expand_path("support/get_names_frequency.json","#{File.dirname(__FILE__)}") 
            json = File.read(path)
            response = double('faraday_response', body: json, status: 200)
            allow(Faraday).to receive(:get).with("https://servicodados.ibge.gov.br/api/v2/censos/nomes/joao%7Cmaria").and_return(response)

            expect{Cli.show_names_frequency('joao, maria')}.to output(
                                            include("| PERÍODO     | JOAO   | MARIA   |",
                                                    "| 1930[       | 60155  | 336477  |",
                                                    "| [2000,2010[ | 794118 | 1111301 |")).to_stdout
        end

    end
end

