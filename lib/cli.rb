require_relative 'state'
require 'terminal-table'

class Cli

    def self.welcome
        puts "Bem vindo! Esta aplicação fornece dados da população brasileira."
    end

    def self.help
        puts "Ajuda"
        puts "  NOMES POR UF\t\t:mostrar nomes mais comuns de um estado"
        puts "  NOMES POR CIDADE\t:mostrar nomes mais comuns de uma cidade"
        puts "  FREQUENCIA\t\t:mostrar a frequencia dos nomes ao longo das décadas"
        puts "  SAIR\t\t\t:encerra a aplicação"
    end
    
    def self.main
        while true
            print "Para lista de todos os comandos digite 'ajuda'."
            print "Digite um comando: "
            input = $stdin.gets.chomp

            break if input.downcase == 'sair'

            case input.downcase
            when "nomes por uf"
                puts '-----NOMES POR UF-----'
            when "nomes por cidade"
                puts '-----NOMES POR CIDADE-----'
            when "frequencia"
                puts '-----FREQUENCIA-----'
            when "ajuda"
                help
            else
              puts "Comando inválido. Digite 'ajuda' para lista de comandos."
            end
        end
    end

    def self.select_uf
        rows = []
        State.all.each do |s|
            rows << [s.uf, s.state]
        end
        uf_table = Terminal::Table.new :headings => ['UF', 'ESTADO'], :rows => rows
        puts uf_table
        print 'Digite a UF que deseja:'
        input = $stdin.gets.chomp

        return input
    end


end