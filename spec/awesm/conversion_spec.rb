require 'spec_helper'

describe Awesm::Conversion do
  let(:json_response) do
    {
      "request" => {
        "action" => "new",
        "awesm_url" => "awe.sm_5WXHo",
        "controller" => "conversion",
        "conversion_type" => "goal_1",
        "conversion_value" => "1230",
        "key" => "f2d8aeb112f1e0bedd7c05653e3265d2622635a3180f336f73b172267f7fe6ee"
      },
      "response" => {
        "conversion" => {
          "account_conversionid" => nil,
          "account_id" => "12",
          "account_userid" => nil,
          "awesm_url" => "awe.sm_5WXHo",
          "clicker_id" => nil,
          "converted_at" => 1317850014,
          "href" => nil,
          "id" => "238ea66b-e267-45cf-85a6-e0c21580f1e6",
          "ip_address" => nil,
          "language" => nil,
          "redirection_id" => "94585739",
          "referrer" => nil,
          "session_id" => nil,
          "type" => "goal_1",
          "user_agent" => nil,
          "value" => 1230
        }
      }
    }.to_json
  end

  let(:json_error_response) do
    {
      "request" => {
        "action" => "new",
        "awesm_url" => "awe.sm_5WXHo",
        "controller" => "conversion",
        "conversion_type" => "goal_1",
        "conversion_value" => 1230,
        "key" => "badkeyabcdefghijklmnopqrstuvwxyz1234567890"
      },
      "error" => {
        "code" => 1000,
        "message" => "Invalid API key"
      }
    }.to_json
  end

  before do
    stub_request(:get, "http://api.awe.sm/conversions/new?key=f2d8aeb112f1e0bedd7c05653e3265d2622635a3180f336f73b172267f7fe6ee&awesm_url=awe.sm_5WXHo&conversion_type=goal_1&conversion_value=1230").
       to_return(:status => 200, :body => json_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
    stub_request(:get, "http://api.awe.sm/conversions/new?key=badkeyabcdefghijklmnopqrstuvwxyz1234567890&awesm_url=awe.sm_5WXHo&conversion_type=goal_1&conversion_value=1230").
       to_return(:status => 400, :body => json_error_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
  end

  describe '.convert' do
    context 'when an error occurs' do
      it 'returns nil' do
        params = {
          :key => "badkeyabcdefghijklmnopqrstuvwxyz1234567890",
          :awesm_url => "awe.sm_5WXHo",
          :conversion_type => "goal_1",
          :conversion_value => 1230
        }
        conversion = Awesm::Conversion.convert(params)
        conversion.should == nil
      end
    end

    context 'when successful' do
      it 'returns an Awesm::Conversion' do
        params = {
          :key => "f2d8aeb112f1e0bedd7c05653e3265d2622635a3180f336f73b172267f7fe6ee",
          :awesm_url => "awe.sm_5WXHo",
          :conversion_type => "goal_1",
          :conversion_value => 1230
        }

        conversion = Awesm::Conversion.convert(params)
        conversion.should be_an_instance_of(Awesm::Conversion)
      end
    end

    it 'gets from the awe.sm conversion api properly' do
      params = {
          :key => "f2d8aeb112f1e0bedd7c05653e3265d2622635a3180f336f73b172267f7fe6ee",
          :awesm_url => "awe.sm_5WXHo",
          :conversion_type => "goal_1",
          :conversion_value => 1230
        }

      conversion = Awesm::Conversion.convert(params)

      a_request(:get, "http://api.awe.sm/conversions/new").
        with(:query => {:key => "f2d8aeb112f1e0bedd7c05653e3265d2622635a3180f336f73b172267f7fe6ee",
             :awesm_url => "awe.sm_5WXHo", :conversion_type => "goal_1", :conversion_value => "1230"}).
        should have_been_made.once
    end
  end
end
