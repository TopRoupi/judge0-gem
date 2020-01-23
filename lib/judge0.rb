require 'faraday'
require 'json'

require 'submission.rb'

module Judge0
  def self.statuses
    resp = Faraday.get('https://api.judge0.com/statuses')
    JSON.parse(resp.body)
  end

  def self.system_info
    resp = Faraday.get('https://api.judge0.com/system_info')
    JSON.parse(resp.body)
  end

  def self.config_info
    resp = Faraday.get('https://api.judge0.com/config_info')
    JSON.parse(resp.body)
  end

  def self.languages
    resp = Faraday.get('https://api.judge0.com/languages')
    JSON.parse(resp.body)
  end

  def self.language(id)
    resp = Faraday.get("https://api.judge0.com/languages/#{id}")
    JSON.parse(resp.body)
  end
end