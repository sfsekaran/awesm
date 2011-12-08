require 'spec_helper'

describe Awesm::Project do

  before do
    Awesm.subscription_key = 'sub-xxxxxx'
    Awesm.application_key = 'app-xxxxxx'
  end

  after do
    Awesm.subscription_key = nil
    Awesm.application_key = nil
  end

  context '.create' do
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
            "name" => "TotallyAwesomeProject",
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
          "code" => 10001,
          "message" => "Project name already exists (not necessarily in your subscription). Please choose another."
        }
      }.to_json
    end

    before do
      stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22TotallyAwesomeProject%22%7D&subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
        to_return(:status => 200, :body => json_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
      stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22ExistingAwesomeProject%22%7D&subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
        to_return(:status => 400, :body => json_error_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
    end

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

  describe '.list' do
    let(:json_response) do
      {
        "request" => {
          "application_key" => "app-xxxxxx",
          "method" => "list",
          "object" => "project",
          "subscription_key" => "sub-xxxxxx"
        },
        "response" => {
          "projects" => [
            {
              "admins" => [
                {
                  "default_project" => "demo",
                  "email" => "jeremiah@example.com",
                  "name" => "Jeremiah Lee",
                  "sharer_id" => "9496x4x0-20xx-012x-58xx-123139064x82",
                  "username" => "jeremiah"
                }
              ],
              "api_key" => "x3x202x0151xxxx207x3xx99xxx3x6xx8x2x1d2xxxx5xx72899986xxxx1080x6",
              "created_at" => "2010-04-02 23:15:59",
              "default_domain" => "demo.awe.sm",
              "domains" => [
                "demo.awe.sm"
              ],
              "name" => "demo",
              "sharers" => [
                {
                  "default_project" => "bunyan_logging",
                  "email" => "paul@example.com",
                  "name" => "Paul Bunyan",
                  "sharer_id" => "8x58x4x0-39x5-012x-8109-123139064x82",
                  "username" => "pbunyan"
                }
              ],
              "updated_at" => "2011-07-21 18:28:16",
              "viewers" => [
                {
                  "default_project" => "appleseeds_blog",
                  "email" => "jonny@example.com",
                  "name" => "Jonny Appleseed",
                  "sharer_id" => "9x69x9x0-42x1-420x-9876-123139064x99",
                  "username" => "jonny"
                }
              ]
            }
          ]
        }
      }.to_json
    end

    let(:json_error_response) do
      {
        "request" => {
          "action" => "list", 
          "subscription_key" => "butt", 
          "application_key" => "tlVC3D", 
          "controller" => "project" 
        },
        "error" => "Invalid subscription key"
      }.to_json
    end

    before do
      stub_request(:post, "http://api.awe.sm/projects/list?subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
        to_return(:status => 200, :body => json_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
      stub_request(:post, "http://api.awe.sm/projects/list?subscription_key=invalid&application_key=app-xxxxxx").
        to_return(:status => 400, :body => json_error_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
    end

    it 'posts to the awe.sm project list api properly' do
      Awesm::Project.list

      a_request(:post, "http://api.awe.sm/projects/list").
        with(:query => {:subscription_key => "sub-xxxxxx", :application_key => "app-xxxxxx"}).
        should have_been_made.once
    end

    context 'when an error occurs' do
      before { Awesm.subscription_key = 'invalid' }
      it 'returns nil' do
        project = Awesm::Project.list
        project.should == nil
      end
    end

    context 'when successful' do
      it 'returns an array of Awesm:Project objects' do
        projects = Awesm::Project.list
        projects.first.should be_an_instance_of(Awesm::Project)
      end
    end
  end

  describe '#api_key' do
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
            "name" => "TotallyAwesomeProject",
            "sharers" => [],
            "updated_at" => "2011-10-25 00:43:49",
            "viewers" => []
          }
        }
      }.to_json
    end

    before do
      stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22TotallyAwesomeProject%22%7D&subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
        to_return(:status => 200, :body => json_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
    end

    it 'returns the awe.sm api_key' do
      project = Awesm::Project.create({ :name => "TotallyAwesomeProject" })
      project.api_key.should == '6xxxxxxxxx58xx0xxx74xx3x76xx83x6x34xx48x7xxxx55x167037818d65x66x'
    end
  end
end
