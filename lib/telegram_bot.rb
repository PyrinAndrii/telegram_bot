class TelegramBot
  TOKEN = ENV['TELEGRAM_BOT_API_TOKEN']

  START = '/start'
  STOP  = '/stop'

  WEATHER_API = {
    CURRENT_WEATHER  => ::Weather::API::CurrentWeather,
    WEATHER_FORECAST => ::Weather::API::WeatherForecast
  }

  WEATHER_METHOD = {
    CURRENT_WEATHER  => :tell_current_weather,
    WEATHER_FORECAST => :tell_weather_forecast
  }

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
      when CURRENT_WEATHER, WEATHER_FORECAST
        tell_instruction unless city

        send_message(weather_info(message.text))
      else
        tell_instruction
      end
    end
  end

  private

  attr_reader :city, :chat_id

  def bot
    @bot ||= Telegram::Bot::Client.run(TOKEN, logger: Logger.new($stderr)) { |bot| return bot }
  end

  def weather_info(forecast_type)
    response = WEATHER_API[forecast_type].new(city).response
    parsed_response = ::Weather::ResponseParser.new(response.body)

    parsed_response.error || decorator.send(WEATHER_METHOD[forecast_type],
                                            parsed_response)
  end

  def weather_keyboard
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: [CURRENT_WEATHER, WEATHER_FORECAST], one_time_keyboard: true
    )
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

  def decorator
    ::Weather::Decorator.new(city)
  end

  def send_message(text, **options)
    required_options = { chat_id: chat_id, text: text }
    options.merge! required_options

    bot.api.send_message(options)
  end
end
