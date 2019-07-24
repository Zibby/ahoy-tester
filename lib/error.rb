def error(e, message)
  Slack.configure do |config|
    config.token = ENV['SLACK']
  end
  slack = Slack::Web::Client.new
  puts message
  slack.chat_postMessage(channel: ENV['CHANNEL'], text: message, as_user: true)
end