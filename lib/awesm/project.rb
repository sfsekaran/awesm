module Awesm
  class Project < Hashie::Mash
    include HTTParty
    base_uri 'http://api.awe.sm/projects'
    format :json

    def self.create(attributes)
      project = self.new(attributes)
      project.save ? project : nil
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

    ####################
    # Instance Methods #
    ####################

    def save
      response = self.class.post('/new', :query => { :application_key => Awesm.application_key, :subscription_key => Awesm.subscription_key, :json => self.to_hash.to_json })
      if response.include?('error')
        # use mash to update error code and message
        update(response)
        false
      else
        update(response['response']['project'])
        true
      end
    end

    def destroy
      response = self.class.post("/#{api_key}/destroy", :query => { :application_key => Awesm.application_key, :subscription_key => Awesm.subscription_key })
      true unless response.has_key?('error')
    end
  end
end
