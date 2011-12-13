require 'spec_helper'

describe Awesm::Stats do
  describe '.range' do
    let(:basic_response) do
      {
        "end_date" => "2011-10-01T00:00:00Z",
        "filters" => [],
        "group_by" => nil,
        "groups" => [],
        "last_offset" => 0,
        "offset" => 0,
        "page" => nil,
        "per_page" => 10,
        "pivot" => nil,
        "pivot_sort_order" => nil,
        "pivot_sort_type" => nil,
        "sort_order" => nil,
        "sort_type" => nil,
        "start_date" => "2011-09-01T00:00:00Z",
        "total_results" => 0,
        "totals" => {
          "clicks" => 166,
          "clicks_per_share" => 2.5538,
          "shares" => 65
        },
        "with_conversions" => false,
        "with_metadata" => false,
        "with_zeros" => false
      }.to_json
    end

    let(:invalid_key_response) do
      {
        "error" => 403,
        "error_message" => "Invalid API key specified"
      }.to_json
    end

    before do
      stub_request(:get, "http://api.awe.sm/stats/range.json?v=3&end_date=2011-10-01&key=5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9&start_date=2011-09-01").
        to_return(:status => 200, :body => basic_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
      stub_request(:get, "http://api.awe.sm/stats/range.json?v=3&end_date=2011-10-01&key=fake_key&start_date=2011-09-01").
        to_return(
          :status => 403,
          :body => invalid_key_response,
          :headers => {
            "x-powered-by" => ["PHP/5.3.2-1ubuntu4.7"],
            "connection"=>["close"],
            "content-type"=>["text/html"],
            "date"=>["Tue, 13 Dec 2011 18:51:20 GMT"],
            "server"=>["Apache/2.2.14 (Ubuntu)"],
            "content-length"=>["57"],
            "vary"=>["Accept-Encoding"]
          })
    end

    it 'gets the stats range api correctly' do
      stats = Awesm::Stats.range(
        :key        => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
        :start_date => '2011-09-01',
        :end_date   => '2011-10-01'
      )

      a_request(:get, "http://api.awe.sm/stats/range.json").
        with(:query => {
          :v          => '3',
          :key        => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
          :start_date => '2011-09-01',
          :end_date   => '2011-10-01'
        }).
        should have_been_made.once
    end

    it 'gets with an incorrect key' do
      stats = Awesm::Stats.range(
        :key        => 'fake_key',
        :start_date => '2011-09-01',
        :end_date   => '2011-10-01'
      )
      stats.should == nil
    end

    it 'returns an instance of Awesm::Stats' do
      stats = Awesm::Stats.range(
        :key        => '5c8b1a212434c2153c2f2c2f2c765a36140add243bf6eae876345f8fd11045d9',
        :start_date => '2011-09-01',
        :end_date   => '2011-10-01'
      )
      stats.should be_an_instance_of(Awesm::Stats)
    end
  end
end
