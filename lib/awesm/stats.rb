module Awesm
  class Stats < Hashie::Mash
    PATH = '/stats'

    def self.range(options)
      response = Awesm.http_client.get "#{Awesm::HOST}#{PATH}/range.json", { :v => 3 }.merge(options)
      json = JSON.parse response.content
      new(json)
    end

    def self.url(options)
      awesm_id = options.delete(:awesm_id)
      response = Awesm.http_client.get "#{Awesm::HOST}#{PATH}/#{awesm_id}.json", { :v => 3 }.merge(options)
      json = JSON.parse response.content
      new(json)
    end
  end
end
