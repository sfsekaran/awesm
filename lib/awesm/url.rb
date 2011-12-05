module Awesm
  class Url
    def self.share(params)
      if required_params_present_for_share?(params)
        "http://api.awe.sm/url/share?v=3&url=#{params[:url]}&key=#{params[:key]}&tool=#{params[:tool]}&channel=#{params[:channel]}&destination=#{params[:destination]}"
      end
    end

    def self.required_params_present_for_share?(params)
      [:url, :key, :tool, :channel, :destination].all? do |param|
        params.include?(param)
      end
    end
  end
end
