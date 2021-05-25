require 'json'
require 'faraday'

class Requester
  def self.request(path)
    response = Faraday.get(path)
    # return [] unless response.success?
    return [] if response.status != 200

    JSON.parse(response.body, symbolize_names: true)
  end
end
