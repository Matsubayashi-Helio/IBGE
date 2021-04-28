require_relative 'state'
require 'terminal-table'
require_relative 'name'
require 'byebug'

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
                uf = select_uf
                show_names_by_uf(uf)
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

    def self.show_names_by_uf(uf)
        state = State.find_by(uf: uf.upcase)
        names = Name.rank_by_location(state.location_id)
        rows = []
        names.each do |n|
            rows << [n[:ranking], n[:nome], n[:frequencia]]
        end
        table_location = Terminal::Table.new title: "NOMES MAIS COMUNS DE #{uf.upcase}", :headings => ['RANK', 'NOME', 'FREQUENCIA'], :rows => rows
        puts table_location
    end

end