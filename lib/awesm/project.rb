module Awesm
  class Project < Hashie::Mash
    include HTTParty
    base_uri 'http://api.awe.sm/projects'

    def self.create(attributes)
      response = post('/new', :query => { :application_key => Awesm.application_key, :subscription_key => Awesm.subscription_key, :json => attributes.to_json })
      if response.has_key?("error")
        nil
      else
        new(response['response']['project'])
      end
    end

    def self.list
      response = post('/list', :query => { :application_key => Awesm.application_key, :subscription_key => Awesm.subscription_key})
      if response.has_key?("error")
        nil
      else
        projects = []
        response['response']['projects'].each do |project|
          projects << new(project)
        end
        projects
      end
    end
  end
end
