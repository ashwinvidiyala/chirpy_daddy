require          'slack-ruby-client'
require          'twitter'

require_relative 'slack_authorization'
# require_relative 'twitter_authorization'

twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key         = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret      = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token         = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret  = ENV['TWITTER_ACCESS_TOKEN_SECRET']
end

slack_client = Slack::RealTime::Client.new

slack_client.on :hello do
  puts "Successfully connected, welcome '#{slack_client.self.name}' to the '#{slack_client.team.name}' team at https://#{slack_client.team.domain}.slack.com."
end

slack_client.on :message do |data|
  puts data
  case data.text
  when 'chirpy hi' then
    slack_client.web_client.chat_postMessage channel: data.channel, text: "Hi <@#{data.user}>!", as_user: true
    
  when /^chirpy.#(.*)$/ then
    tweets = twitter_client
            .search("##{$1}", result_type: 'mixed')
            .take(10)

    tweets.each do |tweet|
      slack_client.web_client.chat_postMessage(
        channel: data.channel,
        text: "#{tweet.user.screen_name}: #{tweet.text}",
        as_user: true
      )
    end

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
