module Awesm
  class Conversion < Hashie::Mash
    PATH = '/conversions'

    def self.convert(params)
      response = Awesm.http_client.get("#{Awesm::HOST}#{PATH}/new", params)
      unless response.status == 200
        nil
      else
        json = JSON.parse response.content
        new(json['response']['conversion'])
      end
    end
  end
end
