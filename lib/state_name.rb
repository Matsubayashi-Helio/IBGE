# require "sinatra/activerecord"
require 'json'

class StateName
    attr_reader :uf, :state, :location_id

    def initialize(state:, uf:, location_id:)
        @state = state
        @uf = uf
        @location_id = location_id
    end

    def self.states
        response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
        return [] if response.status != 200

        json_response = JSON.parse(response.body, symbolize_names: true)
        states = []
        json_response.each do |r|
            states << new(uf: r[:sigla], state: r[:nome], location_id: r[:id])
        end
        return states
    end

    
end