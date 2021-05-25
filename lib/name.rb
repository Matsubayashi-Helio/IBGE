# frozen_string_literal: true

require 'byebug'

class Name
  API = YAML.load_file(File.expand_path('config/api_path.yml', "#{File.dirname(__FILE__)}/.."))

  attr_reader :name, :recurrency, :rank

  def initialize(name:, recurrency:, rank:)
    @name = name
    @recurrency = recurrency
    @rank = rank
  end

  def self.rank_by_location(location, gender = {})
    path = API['development']['base'] + API['development']['rank']

    api_path = path + location.to_s

    api_path += "&sexo=#{gender}" unless gender.empty?

    response = Faraday.get(api_path)
    return [] if response.status != 200

    json_response = JSON.parse(response.body, symbolize_names: true)

    json_response[0][:res]
  end

  def self.names_frequency(names)
    path = API['development']['base'] + API['development']['frequency']

    api_path = path + names.gsub(',', '%7C').gsub(/\s+/, '').to_s
    response = Faraday.get(api_path)
    return [] if response.status != 200

    JSON.parse(response.body, symbolize_names: true)
  end
end
