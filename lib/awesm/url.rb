module Awesm
  class Url < Hashie::Mash
    include HTTParty
    base_uri 'http://api.awe.sm/url'
    REQUIRED_SHARE_PARAMS = [:url, :key, :tool, :channel, :destination].freeze

    # Right now this method only supports the json format
    def self.create(params = {})
      call_api('.json', params)
    end

    def self.share(params = {})
      if required_params_present?(REQUIRED_SHARE_PARAMS, params)
        options = params.clone
        options = options.delete_if{|key,value| REQUIRED_SHARE_PARAMS.include?(key) }
        query = options.map{|k,v| "#{k}=#{v}"}.join('&')
        share_url = "http://api.awe.sm/url/share?v=3&url=#{params[:url]}&key=#{params[:key]}&tool=#{params[:tool]}&channel=#{params[:channel]}&destination=#{params[:destination]}"
        share_url += "&#{query}" if query.length > 0
        share_url
      end
    end

    # Right now this method only supports the json format
    def self.static(params = {})
      call_api('/static.json', params)
    end

    #########
    private #
    #########

    def self.call_api(action, params)
      response = post(action, :query => { :v => 3 }.merge(params))
      response.code >= 400 ? nil : new(response)
    end

    def self.required_params_present?(required_params, params)
      required_params.all? do |param|
        params.include?(param)
      end
    end
  end
end
