require 'telegram/bot'
require 'dotenv/load'

Telegram::Bot::Client.run(ENV['TELEGRAM_BOT_API_TOKEN'], logger: Logger.new($stderr)) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.sendMessage(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")

      bot.logger.info("Bot has sent messege to: #{message.from.first_name}")
    end
  end
end
