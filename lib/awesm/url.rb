module Awesm
  class Url
    REQUIRED_SHARE_PARAMS = [:url, :key, :tool, :channel, :destination].freeze

    def self.share(params = {})
      if required_params_present_for_share?(params)
        options = params.clone
        options = options.delete_if{|key,value| REQUIRED_SHARE_PARAMS.include?(key) }
        query = options.map{|k,v| "#{k}=#{v}"}.join('&')
        share_url = "http://api.awe.sm/url/share?v=3&url=#{params[:url]}&key=#{params[:key]}&tool=#{params[:tool]}&channel=#{params[:channel]}&destination=#{params[:destination]}"
        share_url += "&#{query}" if query.length > 0
        share_url
      end
    end

    def self.required_params_present_for_share?(params)
      REQUIRED_SHARE_PARAMS.all? do |param|
        params.include?(param)
      end
    end
  end
end
