require 'spec_helper'

describe Awesm::Project do
  let(:json_response) do 
    {
      "request" => {
        "application_key" => "app-xxxxxx",
        "json" => "{\"name\" =>\"TotallyAwesomeProject\"}",
        "method" => "new",
        "object" => "project",
        "subscription_key" => "sub-xxxxxx"
      },
      "response" => {
        "project" => {
          "admins" => [],
          "api_key" => "6xxxxxxxxx58xx0xxx74xx3x76xx83x6x34xx48x7xxxx55x167037818d65x66x",
          "created_at" => "2011-10-25 00:43:49",
          "default_domain" => "awe.sm",
          "domains" => [],
          "name" => "myNewProject",
          "sharers" => [],
          "updated_at" => "2011-10-25 00:43:49",
          "viewers" => []
        }
      }
    }.to_json
  end

  let(:json_error_response) do
    {
      "request" => {
        "application_key" => "app-xxxxxx",
        "json" => "{\"name\" =>\"ExistingAwesomeProject\"}",
        "method" => "new",
        "object" => "project",
        "subscription_key" => "sub-xxxxxx"
      },
      "error" => {
        "code"=>10001,
        "message"=>"Project name already exists (not necessarily in your subscription). Please choose another."
      }
    }.to_json
  end

  before do
    Awesm.subscription_key = 'sub-xxxxxx'
    Awesm.application_key = 'app-xxxxxx'
    stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22TotallyAwesomeProject%22%7D&subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
       to_return(:status => 200, :body => json_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
    stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22ExistingAwesomeProject%22%7D&subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
       to_return(:status => 400, :body => json_error_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
  end
  after do
    Awesm.subscription_key = nil
    Awesm.application_key = nil
  end

  context '.create' do
    context 'when an error occurs' do
      it 'returns nil' do
        project = Awesm::Project.create(:name => "ExistingAwesomeProject")
        project.should == nil
      end
    end

    context 'when successful' do
      it 'returns an Awesm::Project' do
        project = Awesm::Project.create(:name => "TotallyAwesomeProject")
        project.should be_an_instance_of(Awesm::Project)
      end
    end

    it 'posts to the awe.sm project creation api properly' do
      Awesm::Project.create({ :name => "TotallyAwesomeProject" })

      a_request(:post, "http://api.awe.sm/projects/new").
        with(:query => {:subscription_key => "sub-xxxxxx", :application_key => "app-xxxxxx", :json => { "name" => "TotallyAwesomeProject" }.to_json }).
        should have_been_made.once
    end
  end

  describe '#api_key' do
    it 'returns the awe.sm api_key' do
      project = Awesm::Project.create({ :name => "TotallyAwesomeProject" })
      project.api_key.should == '6xxxxxxxxx58xx0xxx74xx3x76xx83x6x34xx48x7xxxx55x167037818d65x66x'
    end
  end
end
