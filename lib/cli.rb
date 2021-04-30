require_relative 'state'
require_relative 'city'
require 'terminal-table'
require_relative 'name'
require 'byebug'

class Cli


    def self.welcome
        puts "Bem vindo! Esta aplicação fornece dados da população brasileira."
        puts
        puts
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
                loop do
                    uf = select_uf
                    table = show_names_by_uf(uf)
                    if table
                        puts table
                        break
                    end
                    puts 'UF não encontrada. Verifique se sigla está correta'
                end
            when "nomes por cidade"
                loop do
                city = input_format(get_city_name)
                table = show_names_by_city(city)
                    if table
                        puts table
                        break
                    end
                    puts 'Cidade não encontrada. Verifique se acentuação está correta.'
                end
            when "frequencia"
                loop do
                    names = get_names
                    unless names.empty?
                        show_names_frequency(names)
                        break
                    end
                    puts 'Nome não contabilizado pelo IBGE, ou separador dos nomes está incorreto.'
                end
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

        return input.upcase
    end

    def self.show_names_by_uf(uf)
        state = State.find_by(uf: uf.upcase)
        return nil unless state

        names = Name.rank_by_location(state.location_id)
        rows = []
        # byebug
        names.each do |n|
            percentage = percentage_total(state.population_2019, n[:frequencia])
            rows << [n[:ranking], n[:nome], n[:frequencia], percentage]
        end
        table_location = Terminal::Table.new title: "NOMES MAIS COMUNS DE #{uf.upcase}", :headings => ['RANK', 'NOME', 'FREQUENCIA', '% RELATIVA'], :rows => rows
        return table_location
    end

    def self.get_city_name
        print 'Digite o nome da cidade:'
        input = $stdin.gets.chomp
        return input
    end

    def self.show_names_by_city(city)
        city_obj = City.find_by(city: city)
        return nil unless city_obj

        names = Name.rank_by_location(city_obj.location_id)
        rows = []
        names.each do |n|
            percentage = percentage_total(city_obj.population_2019, n[:frequencia])
            rows << [n[:ranking], n[:nome], n[:frequencia], percentage]
        end
        table_location = Terminal::Table.new title: "NOMES MAIS COMUNS DE #{city.upcase}", :headings => ['RANK', 'NOME', 'FREQUENCIA','% RELATIVA'], :rows => rows
        return table_location
    end

    def self.get_names
        print 'Digite um ou mais nomes, separados por vírgula(,):'
        input = $stdin.gets.chomp
        result = Name.names_frequency(input)
        return result
    end

    def self.show_names_frequency(names)

        # byebug
        rows = []
        heading = ['PERÍODO']
        decade = []
        names.each do |name|
          heading << name[:nome]
          name[:res].each do |h| 
            decade << h[:periodo] #.gsub(/\[/, '')
          end
        end

        decade.uniq!
        teste = decade.uniq.sort
        decade.sort.each do |d|
          row = []
          dec = teste.shift
        #   dec.gsub(/\[/, '')[0..4]
        #   dec[0..4]
          
          if dec == '1930[' then row << '< 1930' else row << dec.gsub(/\[/, '')[0..3] end

          names.each do |name|
            found_decade = name[:res].find { |i| i[:periodo] == d }
            if found_decade then row << found_decade[:frequencia] else row << '*' end
          end
          rows << row
        end

        table_frequency = Terminal::Table.new title: 'FREQUÊNCIA DE NOME POR DÉCADA ATÉ 2010', headings: heading, rows: rows
        for c in 0..2 do table_frequency.align_column(c,:center) end
        puts table_frequency
    end




    def self.percentage_total(location_total, name_total)
        return ((name_total.to_f / location_total.to_f) * 100).ceil(3)
    end

    def self.input_format(input)
        input.downcase!
        words = input.split(" ")
        final_word = words.map do |w|
            if w.size <= 2
                next w.capitalize if w == 'la'  
                next w             
            elsif w.size == 3 and (w == 'dos' or w == 'das' or w =='del')
                next w
            else
                w.capitalize
            end
        end
        return final_word.join(' ')
    end
end
