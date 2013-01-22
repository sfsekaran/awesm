require 'httpclient'
require 'httpclient/include_client'
require 'json'
require 'hashie'

require 'awesm/version'
require 'awesm/project'
require 'awesm/conversion'
require 'awesm/url'
require 'awesm/stats'

module Awesm
  HOST = 'http://api.awe.sm'

  extend HTTPClient::IncludeClient

  include_http_client

  def self.subscription_key=(key)
    @@subscription_key = key
  end

  def self.subscription_key
    @@subscription_key
  end

  def self.application_key=(key)
    @@application_key = key
  end

  def self.application_key
    @@application_key
  end
end
