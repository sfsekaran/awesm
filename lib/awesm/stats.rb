module Awesm
  class Stats < Hashie::Mash
    include HTTParty
    base_uri 'http://api.awe.sm/stats'
    format :json

    def self.range(options)
      response = get '/range.json', :query => { :v => 3 }.merge(options)
      new(response)
    end

    def self.url(options)
      awesm_id = options.delete(:awesm_id)
      response = get "/#{awesm_id}.json", :query => { :v => 3 }.merge(options)
      new(response)
    end
  end
end
