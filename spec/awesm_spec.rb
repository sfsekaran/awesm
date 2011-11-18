require 'spec_helper'

describe Awesm do
  describe '.subscription_key=' do
    it 'sets the subscription key' do
      Awesm.subscription_key = '1234567890abcdef1234567890abcdef'
      Awesm.subscription_key.should == '1234567890abcdef1234567890abcdef'
    end
  end

  describe '.application_key=' do
    it 'sets the application key' do
      Awesm.application_key = '1234567890'
      Awesm.application_key.should == '1234567890'
    end
  end

  after(:each) do
    Awesm.subscription_key = nil
    Awesm.application_key = nil
  end
end
