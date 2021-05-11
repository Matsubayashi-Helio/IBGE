require 'optparse'
require_relative 'lib/cli-test'
require 'byebug'

class Parser
    def self.parse(options)

    opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: app [options]"
        opts.separator ""
        opts.separator "Utilização da aplicação:"
        opts.on('-u [UF]', '--uf [UF]', String, "Nomes mais comuns de UF em três tabelas.", 
                                        "(Tabela de ranking geral e um de cada gênero)") do |uf|
            uf_option(uf)
        end

        opts.on("-cCIDADE", "--cidade CIDADE", String, "Nomes mais comuns de CIDADE em três tabelas.",
                                                    "(Tabela de ranking geral e um de cada gênero)") do |c|
            city_option(c)
        end

        opts.on("-fNOMES", "--frequencia NOMES", Array, "Frequência de NOMES ao longo das decadas") do |n|
            puts n
        end
        
        opts.separator ""
        opts.separator "Opções extras:"
        opts.on_tail("-h", "--help", "Exibe todos os comandos") do
            puts opts
        end
        
        opts.on_tail("-d", "--dicas", "Dicas e informações extras") do
            CliTest.tips
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
            CliTest.show_ufs
            uf = CliTest.user_input_uf
        end  
        
        while table
            uf.strip!
            table = CliTest.show_names_by_uf(uf)
            if table
                puts 'UF inválida, digite novamente' 
                uf = CliTest.user_input_uf
            end
        end
    end

    def self.city_option(input)
        table = true
        city = CliTest.input_format(input)
        while table
            city.strip!
            table = CliTest.show_names_by_city(city)
            if table
                puts 'Cidade não encontrada, vefirique acentuação.'
                city = CliTest.input_format(CliTest.get_city_name)
            end  
        end
    end
end
