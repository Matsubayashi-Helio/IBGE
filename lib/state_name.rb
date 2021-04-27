# require "sinatra/activerecord"
require 'json'

class StateName
    attr_reader :uf, :state

    def initialize(state:, uf:)
        @state = state
        @uf = uf
    end

    def self.states
        response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
        return [] if response.status != 200

        json_response = JSON.parse(response.body, symbolize_names: true)
        states = []
        json_response.each do |r|
            states << new(uf: r[:sigla], state: r[:nome])
        end
        return states
    end

    
end