require 'rubygems'
require 'httparty'

module Awesm
  class Project
    include HTTParty
    base_uri "http://api.awe.sm/projects"

    def initialize(attributes)
      self.class.post("/new", :query => { :subscription_key => attributes[:subscription_key], :json => { :name => attributes[:name] }.to_json })
    end
  end
end


