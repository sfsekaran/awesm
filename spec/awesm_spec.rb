require 'spec_helper'

describe Awesm::Project do
  context '.new' do

    before do
      stub_request(:post, "http://api.awe.sm/projects/new?json=%7B%22name%22:%22Totally%20Awesome%20Project%22%7D&subscription_key=sub-xxxxxx").
         to_return(:status => 200, :body => "", :headers => {})
    end

    it 'creates a project' do
      Awesm::Project.new(:subscription_key => "sub-xxxxxx", :name => "Totally Awesome Project").should be_an_instance_of(Awesm::Project)
    end

    it 'posts to the awe.sm project creation api properly' do
      Awesm::Project.new({ :subscription_key => "sub-xxxxxx", :name => "Totally Awesome Project" })
      a_request(:post, "http://api.awe.sm/projects/new").with(:query => {:subscription_key => "sub-xxxxxx", :json => { "name" => "Totally Awesome Project" }.to_json }).should have_been_made.once
    end
  end
end
