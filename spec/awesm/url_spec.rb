require 'spec_helper'

describe Awesm::Url do

  before do
    Awesm.subscription_key = 'sub-xxxxxx'
    Awesm.application_key = 'app-xxxxxx'
  end

  after do
    Awesm.subscription_key = nil
    Awesm.application_key = nil
  end

  let(:invalid_params) {
    { :bad => "param" }
  }

  describe '.create' do
    let(:api_url) { "http://api.awe.sm/url.json" }

    let(:required_params) {
      {
        :url => 'http://developers.awe.sm/',
        :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
        :tool => 'mKU7uN',
        :channel => 'twitter'
      }
    }

    let(:create_url_response) {
      {
        :application => "test",
        :awesm_id => "demo.awe.sm_K5s",
        :awesm_url => "http://demo.awe.sm/K5s",
        :campaign => nil,
        :campaign_metadata => {
          :description => nil,
          :name => nil
        },
        :channel => "facebook-post",
        :created_at => "2011-10-04T18:00:57Z",
        :domain => "demo.awe.sm",
        :notes => nil,
        :original_url => "http://developers.awe.sm/",
        :parent => nil,
        :path => "K5s",
        :redirect_url => "http://developers.awe.sm/",
        :service => "facebook",
        :service_postid => nil,
        :service_postid_metadata => {
          :reach => nil,
          :shared_at => nil
        },
        :service_userid => nil,
        :sharer_id => nil,
        :tag => nil,
        :tool => "test-main",
        :user_id => nil,
        :user_id_metadata => {
          :icon_url => nil,
          :profile_url => nil,
          :username => nil
        }
      }.to_json
    }

    let(:create_url_error_response) do
      {
        "request" => {
          "action" => "create",
          "awesm_url" => "awe.sm_5WXHo",
          "controller" => "url",
          "key" => "badkeyabcdefghijklmnopqrstuvwxyz1234567890"
        },
        "error" => {
          "code" => 1000,
          "message" => "Invalid API key"
        }
      }.to_json
    end

    before do
      expected_params = required_params.merge(:v => "3")
      stub_request(:post, api_url).
        with(:body => expected_params).
        to_return(:status => 200,
                  :body => create_url_response,
                  :headers => {
                    'Content-Type' => 'application/json;charset=utf-8'
                  })
    end

    context 'when an error occurs' do
      before do
        expected_params = invalid_params.merge(:v => "3")
        stub_request(:post, api_url).
          with(:body => expected_params).
          to_return(:status => 400,
                    :body => create_url_error_response,
                    :headers => {
                      'Content-Type' => 'application/json;charset=utf-8'
                    })
      end

      it 'returns nil' do
        url = Awesm::Url.create(:bad => 'param')
        url.should == nil
      end
    end

    context 'when successful' do
      it 'returns an Awesm::Url' do
        url = Awesm::Url.create(required_params)
        url.should be_an_instance_of(Awesm::Url)
      end
    end

    it 'posts to the awe.sm project creation api properly' do
      expected_query = required_params.merge(:v => "3")
      Awesm::Url.create(required_params)
      a_request(:post, "http://api.awe.sm/url.json").
        with(:body => expected_query).
        should have_been_made.once
    end
  end

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

    [
      [:campaign,             'my-campaign-1'],
      [:campaign_description, 'This is a description. Fun.'],
      [:campaign_name,        'My Campaign 1'],
      [:notes,                'This link is going to take down my site.'],
      [:parent,               'awe.sm_s5d99'],
      [:service_userid,       'twitter:13263'],
      [:tag,                  'My-Tag'],
      [:user_id,              '42'],
      [:user_id,              '42'],
      [:user_id_icon_url,     'http://test.com/users/42/avatar.png'],
      [:user_id_profile_url,  'http://test.com/users/42/'],
      [:user_id_username ,    'johndoe@test.com']
    ].each do |option, value|
       it "returns the correct awe.sm url when also passed a '#{option.to_s}' parameter" do
         Awesm::Url.share(required_parameters.merge(option => value)).
           should == "http://api.awe.sm/url/share?v=3&url=http://developers.awe.sm/&key=5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9&tool=mKU7uN&channel=twitter&destination=http://twitter.com/intent/tweet?text=This+is+the+coolest+API+evar!%26url=AWESM_URL%26via=awesm&#{option.to_s}=#{value}"
       end
     end

  end

  describe '.static' do
    let(:api_url) { "http://api.awe.sm/url/static.json" }

    let(:valid_params) {
      {
        :url => 'http://developers.awe.sm/',
        :key => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
        :tool => 'mKU7uN',
        :channel => 'twitter',
        :user_id => "23291",
        :user_id_username => "jhstrauss",
        :user_id_profile_url => "http://plancast.com/user/23291",
        :user_id_icon_url => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/41657_627286_9900_n.jpg"
      }
    }

    let(:static_url_response) {
      {
        :awesm_url => "http://demo.awe.sm/ELZ",
        :awesm_id => "demo.awe.sm_ELZ",
        :domain => "demo.awe.sm",
        :path => "ELZ",
        :created_at => "2011-08-19T23:39:15Z",
        :redirect_url => "http://plancast.com/p/6xfs/silicon-valley-tweetup-summer-2011?utm_campaign=&utm_medium=demo.awe.sm-copypaste&utm_source=direct-demo.awe.sm&utm_content=test-main",
        :original_url => "http://plancast.com/p/6xfs/silicon-valley-tweetup-summer-2011",
        :channel => "copypaste",
        :service => "copypaste",
        :tool => "test-main",
        :application => "test",
        :parent => nil,
        :sharer_id => nil,
        :username =>nil,
        :service_userid => nil,
        :service_postid => nil,
        :service_postid_metadata => {
          :reach => nil,
          :shared_at => nil
        },
        :campaign => nil,
        :campaign_metadata => {
          :description => nil,
          :name => nil
        },
        :user_id => "23291",
        :user_id_metadata => {
          :icon_url => "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-snc4/41657_627286_9900_n.jpg",
          :username => "jhstrauss",
          :profile_url => "http://plancast.com/user/23291"
        },
        :tag => nil,
        :notes => nil,
        :new => false
      }.to_json
    }

    let(:static_url_error_response) do
      {
        "request" => {
          "action" => "static",
          "awesm_url" => "awe.sm_5WXHo",
          "controller" => "url",
          "key" => "badkeyabcdefghijklmnopqrstuvwxyz1234567890"
        },
        "error" => {
          "code" => 1000,
          "message" => "Invalid API key"
        }
      }.to_json
    end

    before do
      expected_params = valid_params.merge(:v => "3")
      stub_request(:post, api_url).
        with(:body => expected_params).
        to_return(:status => 200,
                  :body => static_url_response,
                  :headers => {
                    'Content-Type' => 'application/json;charset=utf-8'
                  })
    end

    context 'when an error occurs' do
      before do
        expected_params = invalid_params.merge(:v => "3")
        stub_request(:post, api_url).
          with(:body => expected_params).
          to_return(:status => 400,
                    :body => static_url_error_response,
                    :headers => {
                      'Content-Type' => 'application/json;charset=utf-8'
                    })
      end

      it 'returns nil' do
        url = Awesm::Url.static(:bad => 'param')
        url.should == nil
      end
    end

    context 'when successful' do
      it 'returns an Awesm::Url' do
        url = Awesm::Url.static(valid_params)
        url.should be_an_instance_of(Awesm::Url)
      end
    end

    it 'posts to the awe.sm project creation api properly' do
      expected_query = valid_params.merge(:v => "3")
      Awesm::Url.static(valid_params)
      a_request(:post, "http://api.awe.sm/url/static.json").
        with(:body => expected_query).
        should have_been_made.once
    end
  end
end
