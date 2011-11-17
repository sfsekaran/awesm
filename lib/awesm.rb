require 'awesm/version'

require 'httparty'
require 'json'

module Awesm
  def self.subscription_key=(key)
    @@subscription_key = key
  end

  def self.subscription_key
    @@subscription_key
  end

  class Project
    include HTTParty
    base_uri 'http://api.awe.sm/projects'

    def initialize(attributes = {})
      # self.attributes = attributes
    end

    def self.create(attributes)
      response = post('/new', :query => { :subscription_key => Awesm.subscription_key, :json => attributes.to_json })
      Awesm::Project.new(response['response']['project'])
    end
  end
end
