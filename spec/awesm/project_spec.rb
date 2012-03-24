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

  let(:new_project_response) do
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

  let(:new_project_error_response) do
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

  let(:delete_project_response) do
    {
      :request => {
        :apikey => "9x863xx7xx12x56433059xx8091838f5f5589x71x04f4760490x6x79xx9xx681",
        :subscription_key => "sub-xxxxxx",
        :application_key => "app-xxxxxx",
        :object => "project",
        :method => "delete"
      },
      :response => {
        :deleted => true
      }
    }.to_json
  end

  context '.create' do
    before do
      stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22TotallyAwesomeProject%22%7D&subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
        to_return(:status => 200, :body => new_project_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
      stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22ExistingAwesomeProject%22%7D&subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
        to_return(:status => 400, :body => new_project_error_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
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

  describe '.new' do
    it 'accepts project attributes' do
      project = Awesm::Project.new(:name => 'HooHah')
      project.name.should == 'HooHah'
    end
  end

  describe '#save' do
    before do
      stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22TotallyAwesomeProject%22%7D&subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
        to_return(:status => 200, :body => new_project_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
      stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22ExistingAwesomeProject%22%7D&subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
        to_return(:status => 400, :body => new_project_error_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
    end

    let(:project) { Awesm::Project.new(:name => 'TotallyAwesomeProject') }
    let(:existing_project) { Awesm::Project.new(:name => 'ExistingAwesomeProject') }

    context 'with no existing projects' do
      it 'calls the correct project/new api' do
        project.save

        a_request(:post, "http://api.awe.sm/projects/new").
          with(:query => {:subscription_key => "sub-xxxxxx", :application_key => "app-xxxxxx", :json => { "name" => "TotallyAwesomeProject" }.to_json }).
          should have_been_made.once
      end

      it 'returns true' do
        project.save.should == true
      end
    end

    context 'when the project already exists' do
      it 'returns false' do
        existing_project.save.should == false
      end

      it 'sets the error code' do
        existing_project.save
        existing_project.error.code.should == 10001
      end

      it 'sets the error message' do
        existing_project.save
        existing_project.error.message.should == 'Project name already exists (not necessarily in your subscription). Please choose another.'
      end
    end

    it 'updates a project in awe.sm if it exists and attributes have changed'
    it 'does not update a project in awe.sm if it exists and attributes have not changed'
  end

  describe "#destroy" do
    let(:existing_project) { Awesm::Project.new(:name => 'ExistingAwesomeProject', :api_key => '9x863xx7xx12x56433059xx8091838f5f5589x71x04f4760490x6x79xx9xx681') }

    before do
      stub_request(:post, "http://api.awe.sm/projects/9x863xx7xx12x56433059xx8091838f5f5589x71x04f4760490x6x79xx9xx681/destroy?application_key=app-xxxxxx&subscription_key=sub-xxxxxx").
         to_return(:status => 200, :body => delete_project_response, :headers => {})
    end

    it 'posts to the project destroy api' do
      existing_project.destroy

      a_request(:post, "http://api.awe.sm/projects/#{existing_project.api_key}/destroy").
        with(:query => {:subscription_key => "sub-xxxxxx", :application_key => "app-xxxxxx"}).
        should have_been_made.once
    end

    it 'returns true on success' do
      existing_project.destroy.should == true
    end
  end

  describe '.list' do
    let(:list_project_response) do
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

    let(:list_project_error_response) do
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
        to_return(:status => 200, :body => list_project_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
      stub_request(:post, "http://api.awe.sm/projects/list?subscription_key=invalid&application_key=app-xxxxxx").
        to_return(:status => 400, :body => list_project_error_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
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
    before do
      stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22TotallyAwesomeProject%22%7D&subscription_key=sub-xxxxxx&application_key=app-xxxxxx").
        to_return(:status => 200, :body => new_project_response, :headers => { 'Content-Type' => 'application/json;charset=utf-8' })
    end

    it 'returns the awe.sm api_key' do
      project = Awesm::Project.create({ :name => "TotallyAwesomeProject" })
      project.api_key.should == '6xxxxxxxxx58xx0xxx74xx3x76xx83x6x34xx48x7xxxx55x167037818d65x66x'
    end
  end
end
