require 'spec_helper'

describe Awesm do
  describe '.subscription_key=' do
    it 'sets the subscription key' do
      Awesm.subscription_key = '1234567890abcdef1234567890abcdef'
      Awesm.subscription_key.should == '1234567890abcdef1234567890abcdef'
    end
  end

  after(:each) { Awesm.subscription_key = nil }
end

describe Awesm::Project do
  context '.create' do
    let(:json_response) do
      %|
        {
          "request": {
              "json": "{\"name\":\"Totally Awesome Project\"}",
              "method": "new",
              "object": "project",
              "subscription_key": "sub-xXXxXxxX"
          },
          "response": {
              "project": {
                  "admins": [],
                  "api_key": "6xxxxxxxxx58xx0xxx74xx3x76xx83x6x34xx48x7xxxx55x167037818d65x66x",
                  "created_at": "2011-10-25 00:43:49",
                  "default_domain": "awe.sm",
                  "domains": [],
                  "name": "myNewProject",
                  "sharers": [],
                  "updated_at": "2011-10-25 00:43:49",
                  "viewers": []
              }
          }
        }
      |
    end

    before do
      stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22Totally%20Awesome%20Project%22%7D&subscription_key=sub-xxxxxx").
         to_return(:status => 200, :body => json_response, :headers => {})
    end

    it 'returns an Awesm::Project' do
      Awesm.subscription_key = 'sub-xxxxxx'
      project = Awesm::Project.create(:name => "Totally Awesome Project")
      project.should be_an_instance_of(Awesm::Project)
    end

    it 'posts to the awe.sm project creation api properly' do
      Awesm.subscription_key = 'sub-xxxxxx'
      Awesm::Project.create({ :name => "Totally Awesome Project" })

      a_request(:post, "http://api.awe.sm/projects/new").
        with(:query => {:subscription_key => "sub-xxxxxx", :json => { "name" => "Totally Awesome Project" }.to_json }).
        should have_been_made.once
    end
  end

  after(:each) { Awesm.subscription_key = nil }
end
