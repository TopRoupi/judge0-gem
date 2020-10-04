require 'faraday'
require 'json'

require 'submission.rb'

module Judge0
  @@base_url = 'http://roupi.xyz:3000/'

  def self.base_url=(url)
    @@base_url = url
  end

  def self.url(params = '')
    @@base_url + params
  end

  def self.statuses
    resp = Faraday.get(url '/statuses')
    JSON.parse(resp.body)
  end

  def self.system_info
    resp = Faraday.get(url '/system_info')
    JSON.parse(resp.body)
  end

  def self.config_info
    resp = Faraday.get(url '/config_info')
    JSON.parse(resp.body)
  end

  def self.languages
    resp = Faraday.get(url '/languages')
    JSON.parse(resp.body)
  end

  def self.language(id)
    resp = Faraday.get(url "/languages/#{id}")
    JSON.parse(resp.body)
  end
end
