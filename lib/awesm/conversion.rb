module Awesm
  class Conversion < Hashie::Mash
    include HTTParty
    base_uri 'http://api.awe.sm/conversions'

    def self.convert(params)
      response = get('/new', :query => params)
      if response.has_key?("error")
        nil
      else
        new(response['response']['conversion'])
      end
    end
  end
end
