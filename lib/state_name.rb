# require "sinatra/activerecord"
require 'json'

class StateName
    attr_reader :initials, :state

    def initialize(state:, initials:)
        @state = state
        @initials = initials
    end

    def self.states
        response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome')
        return [] if response.status != 200

        json_response = JSON.parse(response.body, symbolize_names: true)
        states = []
        json_response.each do |r|
            states << new(initials: r[:sigla], state: r[:nome])
        end
        return states
    end

    
end