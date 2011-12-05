require 'spec_helper'

describe Awesm::Url do
  describe '.share' do
    it 'returns the correct awe.sm url' do
      Awesm::Url.share(:url => 'http://developers.awe.sm/',
                       :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
                       :tool => 'mKU7uN',
                       :channel => 'twitter',
                       :destination => 'http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm').
        should == 'http://api.awe.sm/url/share?v=3&url=http://developers.awe.sm/&key=5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9&tool=mKU7uN&channel=twitter&destination=http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm'
    end

    it 'returns nil if no options are sent in' do
      Awesm::Url.share({}).should == nil
    end
  end
end

