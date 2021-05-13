require 'optparse'
require_relative 'cli'
require 'byebug'

class Parser
    def self.parse(options)

    opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: app [options]"
        opts.separator ""
        opts.separator "Utilização da aplicação:"
        opts.on("-u [UF]", "--uf [UF]", String, "Nomes mais comuns de UF em três tabelas.", 
                                        "(Tabela de ranking geral e um de cada gênero)") do |uf|
            uf_option(uf)
        end

        opts.on("-c CIDADE", "--cidade=CIDADE", String, "Nomes mais comuns de CIDADE em três tabelas.",
                                                    "(Tabela de ranking geral e um de cada gênero)") do |c|
            city_option(c)
        end

        opts.on("-f NOMES", "--frequencia=NOMES", Array, "Frequência de NOMES ao longo das decadas") do |nn|
            # byebug
            frequency_option(nn)
        end
        
        opts.separator ""
        opts.separator "Opções extras:"
        opts.on_tail("-h", "--help", "Exibe todos os comandos") do
            puts opts
        end
        
        opts.on_tail("-d", "--dicas", "Dicas e informações extras") do
            tips
        end
        
        opts.on_tail('-x', '--sair', 'Sair da aplicação') do
            exit
        end
    end

    opt_parser.parse!(options)
    end


    def self.uf_option(uf = {})
        table = true
        unless uf
            Cli.show_ufs
            uf = Cli.user_input_uf
        end  
        
        while table
            uf.strip!
            table = Cli.show_names_by_uf(uf)
            if table
                puts 'UF inválida, digite novamente' 
                uf = Cli.user_input_uf
            end
        end
    end

    def self.city_option(input)
        table = true
        city = Cli.input_format(input)
        while table
            city.strip!
            table = Cli.show_names_by_city(city)
            if table
                puts 'Cidade não encontrada, vefirique acentuação.'
                city = Cli.input_format(Cli.get_city_name)
            end  
        end
    end

    def self.frequency_option(input)
        names = input.join(',')
        api_names = Name.names_frequency(names)
        loop do
            
            unless api_names.empty?
                Cli.show_names_frequency(api_names)
                break
            end
            puts 'Nome não contabilizado pelo IBGE, ou separador dos nomes está incorreto.'
            api_names = Cli.get_names
        end
    end

    def self.tips
        puts 
        puts 
        puts 'Algumas dicas para a consulta de nomes ou localidades:'
        puts 
        puts
    
        puts '---> Verifique se cidade/estado possui acentos'
        puts
        puts '---> Caso nenhuma UF for informada no comando --uf, uma lista'
        puts '     com todas as UFs será exibida para consulta.'
        puts
        puts '---> Nomes compostos não foram considerados.'
        puts '     Somente nomes singulares retornarão a frequencia.'
        puts
        puts '---> Para a consulta de mais de um nome por vez utilize'
        puts '     o separador vírgula(,) sem espaco entre os nomes.'
        puts '     Ex: Ana, Pedro, Maria'
        puts
        puts '---> Não são considerados acentos na busca de nomes.'
        puts '     Ambos Antônio e Antonio se referem ao mesmo nome.'
        puts
        puts '---> A quantidade mínima de ocorrências para que o nome seja'
        puts '     considerado é de 10 por município e 15 por UF.'
        puts
        puts
    end
end

# o = '--frequencia=aasdasfasd'
# Parser.parse %W[#{o}]
