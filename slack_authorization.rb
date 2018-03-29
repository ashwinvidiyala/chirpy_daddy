require 'dotenv'
require 'slack-ruby-client'

Dotenv.load('development.env')

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end
