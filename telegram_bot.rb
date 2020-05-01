require 'telegram/bot'
require 'pry' # TODO: just for debugging

class TelegramBot
  TOKEN = ENV['TELEGRAM_BOT_API_TOKEN']
  CURRENT_WEATHER  = 'Current weather'
  WEATHER_FORECAST = 'Weather forecast'

  attr_reader :city, :chat_id

  # TODO: just hint, will delete later
  # def run
  #   bot.listen do |message|
  #     # case message.text
  #     # when '/start'
  #       bot.api.sendMessage(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
  #       weather_message(message)
  #
  #       bot.logger.info("Bot has sent message to: #{message.from.first_name}")
  #     # end
  #   end
  # end

  def run
    bot.listen do |message|
      case message
      when Telegram::Bot::Types::CallbackQuery
        @chat_id = message.message.chat.id

        if message.data == 'current'
          current_weather
        elsif message.data == 'forecast'
          weather_forecast # TODO: finish implementation of weather forecast
        end
      when Telegram::Bot::Types::Message
        @chat_id = message.chat.id
        ask_type_of_weather
      end
    end
  end

  def ask_type_of_weather
    bot.api.send_message(
      chat_id: chat_id,
      text: 'Do you want to know current weather, or forecast?',
      reply_markup: markup
    )
  end

  def markup
    Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: weather_buttons)
  end

  def weather_buttons
    [
      Telegram::Bot::Types::InlineKeyboardButton.new(text: CURRENT_WEATHER,  callback_data: 'current'),
      Telegram::Bot::Types::InlineKeyboardButton.new(text: WEATHER_FORECAST, callback_data: 'forecast')
    ]
  end

  def current_weather
    enter_city

    tell_weather
  end

  # TODO: finish implementation of weather forecast
  # def weather_forecast(callback_data)
  #   enter_city
  #   return 'doesn`t work currently, in progress'
  #
  #   weather_message(city)
  # end

  def enter_city
    bot.api.sendMessage(chat_id: chat_id, text: 'Please enter your city')
    @city = 'lviv' # TODO: implement entering city

    # bot.listen do |message|
    #   p chat_id
    #   p message
    #   @city = message.message.text.strip.tr(' ', '+')
    #   p city
    # end
  end

  private

  def bot
    @bot ||= Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stderr)) { |bot| return bot }
  end

  def weather_info
    Weather::Decorator.new(city).tell_current_weather
  end

  def tell_weather
    bot.api.sendMessage(chat_id: chat_id, text: weather_info)
  end
end
