class CityName

    attr_reader :initials, :state, :city

    def initialize(state:, initials:, city:)
        @state = state
        @initials = initials
        @city = city
    end

    def self.cities
        response = Faraday.get('https://servicodados.ibge.gov.br/api/v1/localidades/municipios?orderBy=nome')
        return [] if response.status != 200

        json_response = JSON.parse(response.body, symbolize_names: true)
        cities = []
        json_response.each do |r|
            cities << new(city: r[:nome], state: r[:microrregiao][:mesorregiao][:UF][:nome],
                                        initials: r[:microrregiao][:mesorregiao][:UF][:sigla])
        end
        # byebug
        return cities
    end

end