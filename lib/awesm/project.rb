module Awesm
  class Project < Hashie::Mash
    PATH = '/projects'

    def self.create(attributes)
      project = self.new(attributes)
      project.save ? project : nil
    end

    def self.list
      response = Awesm.http_client.post("#{Awesm::HOST}#{PATH}/list", { :application_key => Awesm.application_key, :subscription_key => Awesm.subscription_key})
      unless response.status == 200
        nil
      else
        projects = []
        json = JSON.parse response.content
        json['response']['projects'].each do |project|
          projects << new(project)
        end
        projects
      end
    end

    ####################
    # Instance Methods #
    ####################

    def save
      response = Awesm.http_client.post("#{Awesm::HOST}#{PATH}/new", :application_key => Awesm.application_key, :subscription_key => Awesm.subscription_key, :json => self.to_hash.to_json)
      json = JSON.parse response.content
      unless response.status.between? 200, 230
        # use mash to update error code and message
        update(json)
        false
      else
        update(json['response']['project'])
        true
      end
    end

    def destroy
      response = Awesm.http_client.post("#{Awesm::HOST}#{PATH}/#{api_key}/destroy", { :application_key => Awesm.application_key, :subscription_key => Awesm.subscription_key })
      response.status == 200
    end
  end
end
