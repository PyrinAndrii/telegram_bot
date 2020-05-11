require_relative './lib/weather/decorator'

require 'telegram/bot'
require 'pry' # TODO: just for debugging, delete later

class TelegramBot
  TOKEN = ENV['TELEGRAM_BOT_API_TOKEN']

  START            = '/start'
  STOP             = '/stop'
  CURRENT_WEATHER  = 'Current weather'
  WEATHER_FORECAST = 'Weather forecast'

  # match if command start with '/city', has a space and 1 or more letters
  CITY_REGEXP = /^\/city \w+/

  attr_reader :city, :chat_id

  def run
    bot.listen do |message|
      @chat_id ||= message.chat.id

      case message.text
      when START
        question = "Do you want to know #{CURRENT_WEATHER} or #{WEATHER_FORECAST}?"

        bot.api.send_message(chat_id: chat_id, text: question, reply_markup: weather_keyboard)
      when STOP
        good_by
      when CITY_REGEXP
        city_name(message.text)

        bot.api.send_message(chat_id: chat_id, text: choose_forecast_type)

        # TODO: add logger
        # bot.logger.info("Bot has sent message to: #{message.from.first_name}")
      when CURRENT_WEATHER
        tell_current_weather
      when WEATHER_FORECAST
        tell_weather_forecast
      else
        tell_instruction
      end
    end
  end

  def weather_keyboard
    Telegram::Bot::Types::ReplyKeyboardMarkup
      .new(keyboard: [CURRENT_WEATHER, WEATHER_FORECAST], one_time_keyboard: true)
  end

  def city_name(text)
    @city = text.gsub('/city', '').strip.tr(' ', '+')
  end

  def good_by
    delete_keyboard = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)

    bot.api.send_message(chat_id: chat_id, text: 'Sorry to see you go :(', reply_markup: delete_keyboard)
  end

  def choose_forecast_type
    "Next type /start and choose either #{CURRENT_WEATHER} or #{WEATHER_FORECAST}"
  end

  def tell_instruction
    instruction = "Please type /city {city_name} where 'city_name' is the city you want to know the weather about\n"
    instruction += choose_forecast_type

    bot.api.send_message(chat_id: chat_id, text: instruction)
  end

  private

  def bot
    @bot ||= Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stderr)) { |bot| return bot }
  end

  def tell_weather_forecast
    return tell_instruction unless city

    bot.api.sendMessage(chat_id: chat_id, text: weather_forecast_info)
  end

  def tell_current_weather
    return tell_instruction unless city

    bot.api.sendMessage(chat_id: chat_id, text: current_weather_info)
  end

  def current_weather_info
    Weather::Decorator.new(city).tell_current_weather
  end

  def weather_forecast_info
    Weather::Decorator.new(city).tell_weather_forecast
  end

# TODO: make method for sending messages
  def send_message(text, *options)
    # bot.api.send_message(chat_id: chat_id, text: text, options)
  end
end
