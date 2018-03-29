require 'slack-ruby-client'

require_relative 'slack_authorization'

slack_client = Slack::RealTime::Client.new

slack_client.on :hello do
  puts "Successfully connected, welcome '#{slack_client.self.name}' to the '#{slack_client.team.name}' team at https://#{slack_client.team.domain}.slack.com."
end

slack_client.on :message do |data|
  puts data
  case data.text
  when 'chirpy hi' then
    slack_client.web_client.chat_postMessage channel: data.channel, text: "Hi <@#{data.user}>!", as_user: true
  when /^chirpy.#(.*)/ then
    slack_client.web_client.chat_postMessage channel: data.channel, text: "Your Hashtag is #{$1}!", as_user: true
  when /^chirpy/ then
    slack_client.web_client.chat_postMessage channel: data.channel, text: "Sorry <@#{data.user}>, what?", as_user: true
  end
end

slack_client.on :close do |_data|
  puts "Client is about to disconnect"
end

slack_client.on :closed do |_data|
  puts "Client has disconnected successfully!"
end

slack_client.start!
