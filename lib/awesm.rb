require 'awesm/version'

require 'httparty'
require 'json'
require 'hashie'
require 'ruby-debug'

module Awesm
  def self.subscription_key=(key)
    @@subscription_key = key
  end

  def self.subscription_key
    @@subscription_key
  end

  def self.application_key=(key)
    @@application_key = key
  end

  def self.application_key
    @@application_key
  end

  class Project < Hashie::Mash
    include HTTParty
    base_uri 'http://api.awe.sm/projects'

    def self.create(attributes)
      response = post('/new', :query => { :application_key => Awesm.application_key, :subscription_key => Awesm.subscription_key, :json => attributes.to_json })
      new(response['response']['project'])
    end
  end
end
