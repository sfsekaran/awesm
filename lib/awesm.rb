require 'awesm/version'

require 'httparty'
require 'json'

module Awesm
  class Project
    include HTTParty
    base_uri 'http://api.awe.sm/projects'

    def initialize(attributes = {})
      # self.attributes = attributes
    end

    def self.create(attributes)
      response = post('/new', :query => { :subscription_key => attributes[:subscription_key], :json => { :name => attributes[:name] }.to_json })
      Awesm::Project.new(response['response']['project'])
    end
  end
end
