require_relative 'state'
require_relative 'city'
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
                city = get_city_name
                show_names_by_city(city)
            when "frequencia"
                names = get_names
                show_names_frequency(names)
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

    def self.get_city_name
        print 'Digite o nome da cidade:'
        input = $stdin.gets.chomp
        return input
    end

    def self.show_names_by_city(city)
        city_obj = City.find_by(city: city)

        names = Name.rank_by_location(city_obj.location_id)
        rows = []
        names.each do |n|
            rows << [n[:ranking], n[:nome], n[:frequencia]]
        end
        table_location = Terminal::Table.new title: "NOMES MAIS COMUNS DE #{city.upcase}", :headings => ['RANK', 'NOME', 'FREQUENCIA'], :rows => rows
        puts table_location
    end

    def self.get_names
        print 'Digite um ou mais nomes, separados por vírgula(,):'
        input = $stdin.gets.chomp
        return input
    end

    def self.show_names_frequency(names)
        result = Name.names_frequency(names)
        rows = []
        heading = ['PERÍODO']
        decade = []
        result.each do |name|
          heading << name[:nome]
          name[:res].each do |h| 
            decade << h[:periodo] #.gsub(/\[/, '')
          end
        end

        decade.uniq!.each do |d|
          row = []
          row << d

          result.each do |name|
            found_decade = name[:res].find { |i| i[:periodo] == d }
            row << found_decade[:frequencia] if found_decade
          end
          rows << row
        end

        table_frequency = Terminal::Table.new title: 'FREQUÊNCIA DE NOME POR DÉCADA', headings: heading, rows: rows
        puts table_frequency
    end

end


  