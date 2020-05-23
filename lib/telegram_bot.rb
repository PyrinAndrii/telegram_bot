class TelegramBot
  TOKEN = ENV['TELEGRAM_BOT_API_TOKEN']

  START = '/start'
  STOP  = '/stop'

  attr_reader :city, :chat_id

  def run
    bot.listen do |message|
      @chat_id ||= message.chat.id

      case message.text
      when START
        question = "Do you want to know #{CURRENT_WEATHER} or #{WEATHER_FORECAST}?"

        send_message(question, reply_markup: weather_keyboard)
      when STOP
        good_by
      when CITY_REGEXP
        city_name(message.text)

        send_message(choose_forecast_type)

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

    send_message('Sorry to see you go :(', reply_markup: delete_keyboard)
  end

  def choose_forecast_type
    "Next type /start and choose either #{CURRENT_WEATHER} or #{WEATHER_FORECAST}"
  end

  def tell_instruction
    instruction = "Please type /city {city_name} where 'city_name' is the city you want to know the weather about\n"
    instruction += choose_forecast_type

    send_message(instruction)
  end

  private

  def bot
    @bot ||= Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stderr)) { |bot| return bot }
  end

  def tell_weather_forecast
    return tell_instruction unless city

    send_message(weather_forecast_info)
  end

  def tell_current_weather
    return tell_instruction unless city

    send_message(current_weather_info)
  end

  def current_weather_info
    response = ::Weather::API::CurrentWeather.new(city).response
    parsed_response = ::Weather::ResponseParser.new(response.body)

    return parsed_response.error if parsed_response.failure?

    ::Weather::Decorator.new(city).tell_current_weather(parsed_response)
  end

  def weather_forecast_info
    response = ::Weather::API::WeatherForecast.new(city).response
    parsed_response = ::Weather::ResponseParser.new(response.body)

    return parsed_response.error if parsed_response.failure?

    ::Weather::Decorator.new(city).tell_weather_forecast(parsed_response)
  end

  def send_message(text, **options)
    required_options = { chat_id: chat_id, text: text }
    options.merge! required_options

    bot.api.send_message(options)
  end
end
