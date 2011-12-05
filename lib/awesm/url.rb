module Awesm
  class Url
    def self.share(params)
      if share_params_present?(params)
        "http://api.awe.sm/url/share?v=3&url=#{params[:url]}&key=#{params[:key]}&tool=#{params[:tool]}&channel=#{params[:channel]}&destination=#{params[:destination]}"
      end
    end

    def self.share_params_present?(params)
      [:url, :key, :tool, :channel, :destination].all? do |param|
        params.include?(param)
      end
    end
  end
end
