require 'json'
require 'byebug'

class Name

    IBGE_NAMES_API = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking'

    attr_reader :name, :recurrency, :rank

    def initialize(name:, recurrency:, rank:)
        @name = name
        @recurrency = recurrency
        @rank = rank
    end

    def self.rank_by_location(location)
        response = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade=#{location}")
        return [] if response.status != 200

        json_response = JSON.parse(response.body, symbolize_names: true)

        return json_response[0][:res]
    end

    def self.rank_by_gender(gender)
        response = Faraday.get("https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?sexo=#{gender}")
        return [] if response.status != 200

        json_response = JSON.parse(response.body, symbolize_names: true)

        return json_response[0][:res]
    end
end
