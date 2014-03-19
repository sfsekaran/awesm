module Awesm
  class Url < Hashie::Mash
    PATH = '/url'
    REQUIRED_SHARE_PARAMS = [:url, :key, :tool, :channel, :destination].freeze

    # Right now this method only supports the json format
    def self.create(params = {})
      call_api("#{Awesm::HOST}#{PATH}.json", params)
    end

    def self.share(params = {})
      if required_params_present?(REQUIRED_SHARE_PARAMS, params)
        options = params.clone
        options = options.delete_if{|key,value| REQUIRED_SHARE_PARAMS.include?(key) }
        query = options.map{|k,v| "#{k}=#{v}"}.join('&')
        share_url = "#{Awesm::HOST}#{PATH}/share?v=3&url=#{params[:url]}&key=#{params[:key]}&tool=#{params[:tool]}&channel=#{params[:channel]}&destination=#{params[:destination]}"
        share_url += "&#{query}" if query.length > 0
        share_url
      end
    end

    # Right now this method only supports the json format
    def self.static(params = {})
      call_api("#{Awesm::HOST}#{PATH}/static.json", params)
    end

    def self.update(awesm_id, params)
      call_api("#{Awesm::HOST}#{PATH}/update/#{awesm_id}.json", params)
    end

    #########
    private #
    #########

    def self.call_api(action, params)
      response = Awesm.http_client.post(action, { :v => 3 }.merge(params))
      json = JSON.parse response.content
      new(json)
    end

    def self.required_params_present?(required_params, params)
      required_params.all? do |param|
        params.include?(param)
      end
    end
  end
end
