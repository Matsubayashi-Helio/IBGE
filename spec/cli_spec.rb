require 'spec_helper'
require 'cli'

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
    end
end

