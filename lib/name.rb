# frozen_string_literal: true

require 'json'
require 'byebug'
require 'faraday'

class Name
  IBGE_NAMES_API = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes/ranking?localidade='
  IGBE_NAMES_API_FREQUENCY = 'https://servicodados.ibge.gov.br/api/v2/censos/nomes/'

  attr_reader :name, :recurrency, :rank

  def initialize(name:, recurrency:, rank:)
    @name = name
    @recurrency = recurrency
    @rank = rank
  end

  def self.rank_by_location(location, gender = {})
    api_path = IBGE_NAMES_API + location.to_s

    api_path += "&sexo=#{gender}" unless gender.empty?

    response = Faraday.get(api_path)
    return [] if response.status != 200

    json_response = JSON.parse(response.body, symbolize_names: true)

    json_response[0][:res]
  end

  def self.names_frequency(names)
    # byebug
    api_path = IGBE_NAMES_API_FREQUENCY + names.gsub(',', '%7C').gsub(/\s+/, '').to_s
    response = Faraday.get(api_path)
    return [] if response.status != 200

    JSON.parse(response.body, symbolize_names: true)
  end
end
