# require "sinatra/activerecord"
require 'json'

class StateName

    IBGE_LOCALIDADES_API_ESTADOS = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome'.freeze

    attr_reader :uf, :name, :location_id

    def initialize(name:, uf:, location_id:)
        @name = name
        @uf = uf
        @location_id = location_id
    end

    def self.states
        response = Faraday.get(IBGE_LOCALIDADES_API_ESTADOS)
        return [] if response.status != 200

        json_response = JSON.parse(response.body, symbolize_names: true)
        states = []
        json_response.each do |r|
            states << new(uf: r[:sigla], name: r[:nome], location_id: r[:id])
        end
        return states
    end

    
end