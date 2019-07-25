def error(err, message)
  Slack.configure do |config|
    config.token = ENV['SLACK']
  end
  slack = Slack::Web::Client.new
  slack.chat_postMessage(
    channel: ENV['CHANNEL'],
    text: "#{message} because #{err}",
    as_user: true
  )
end
