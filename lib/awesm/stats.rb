module Awesm
  class Stats < Hashie::Mash
    include HTTParty
    base_uri 'http://api.awe.sm/stats'
    format :json

    def self.range(options)
      response = get '/range.json', :query => { :v => 3 }.merge(options)
      if response.has_key?('error')
        nil
      else
        new(response)
      end
    end
  end
end
