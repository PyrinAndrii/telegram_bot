require 'telegram/bot'

class TelegramBot
  TOKEN = ENV['TELEGRAM_BOT_API_TOKEN']

  def run
    bot.listen do |message|
      # case message.text
      # when '/start'
        bot.api.sendMessage(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
        weather_message(message)

        bot.logger.info("Bot has sent message to: #{message.from.first_name}")
      # end
    end
  end

  private

  def bot
    Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stderr)) { |bot| return bot }
  end

  def weather_message(message)
    return unless message.text.include? '/current_weather'

    tell_weather(message.chat.id, weather(message))
  end

  def tell_weather(chat_id, weather_info)
    bot.api.sendMessage(chat_id: chat_id, text: weather_info)
  end

  def weather(message)
    city = get_city(message.text)
    Weather::Decorator.new(city).tell_current_weather
  end

  def get_city(text)
    text.gsub('/current_weather', '').strip.tr(' ', '+')
  end
end
