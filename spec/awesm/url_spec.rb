require 'spec_helper'

describe Awesm::Url do
  describe '.share' do
    let(:required_parameters) do
      {
        :url => 'http://developers.awe.sm/',
        :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
        :tool => 'mKU7uN',
        :channel => 'twitter',
        :destination => 'http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm'
      }
    end

    it 'returns the correct awe.sm url when passed the required parameters' do
      Awesm::Url.share(:url => 'http://developers.awe.sm/',
                       :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
                       :tool => 'mKU7uN',
                       :channel => 'twitter',
                       :destination => 'http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm').
        should == 'http://api.awe.sm/url/share?v=3&url=http://developers.awe.sm/&key=5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9&tool=mKU7uN&channel=twitter&destination=http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm'
    end

    it 'returns nil if it receives an empty hash' do
      Awesm::Url.share({}).should == nil
    end

    it 'returns nil if it receives nothing' do
      Awesm::Url.share.should == nil
    end

    [[:campaign,             'my-campaign-1'],
     [:campaign_description, 'This is a description. Fun.'],
     [:campaign_name,        'My Campaign 1'],
     [:notes,                'This link is going to take down my site.'],
     [:parent,               'awe.sm_s5d99'],
     [:service_userid,       'twitter:13263'],
     [:tag,                  'My-Tag'],
     [:user_id,              '42']].each do |option, value|
      it "returns the correct awe.sm url when also passed a '#{option.to_s}' parameter" do
        Awesm::Url.share(required_parameters.merge(option => value)).
          should == "http://api.awe.sm/url/share?v=3&url=http://developers.awe.sm/&key=5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9&tool=mKU7uN&channel=twitter&destination=http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm&#{option.to_s}=#{value}"
      end
    end

  end
end

