require 'slack-ruby-client'

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

client = Slack::RealTime::Client.new

client.on :hello do
  puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
end

client.on :message do |data|
  puts data
  case data.text
  when 'chirpy hi' then
    client.web_client.chat_postMessage channel: data.channel, text: "Hi <@#{data.user}>!", as_user: true
  when /^chirpy.#(.*)/ then
    client.web_client.chat_postMessage channel: data.channel, text: "Your Hashtag is #{$1}!", as_user: true
  when /^chirpy/ then
    client.web_client.chat_postMessage channel: data.channel, text: "Sorry <@#{data.user}>, what?", as_user: true
  end
end

client.on :close do |_data|
  puts "Client is about to disconnect"
end

client.on :closed do |_data|
  puts "Client has disconnected successfully!"
end



client.start!
