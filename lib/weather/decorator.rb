require_relative 'per_day_parser'
require_relative 'response_parser'
require_relative 'api/current_weather'
require_relative 'api/weather_forecast'

module Weather
  class Decorator
    extend Forwardable

    MAX_MESSAGE_LENGTH = 4096

    attr_reader :city, :parsed_response

    def_delegators :parsed_response, :cod, :message

    def initialize(city)
      @city = city
    end

    def tell_current_weather
      response = API::CurrentWeather.new(city).response
      parse_response(response)

      return message unless cod == ResponseParser::SUCCESS_RESPONSE_CODE

      current = parsed_response.current_weather

      "Now in #{city} is #{current.temp}°C, but feels like #{current.feels_like}°C. "\
      "Also now is #{current.description}"
    end

    def tell_weather_forecast
      response = API::WeatherForecast.new(city).response
      parse_response(response)

      return message unless cod == ResponseParser::SUCCESS_RESPONSE_CODE

      per_day = PerDayParser.new(parsed_response.forecast_list).average_weather_per_day

      text = per_day.map do |day, weather|
        "#{day} in #{city} will be #{weather.temp}°C, but feels like #{weather.feels_like}°C. "\
        "Also there will be #{weather.description}"
      end.join("\n")

      return message_to_long if text.length >= MAX_MESSAGE_LENGTH
      text
    end

    def parse_response(response)
      @parsed_response = ResponseParser.new(response.body)
    end

    def parsed_weather
      parsed_response.parsed_weather
    end

    def parsed_main_data
      parsed_response.parsed_main_data
    end

    def message_to_long
      'Sorry message is too long'
    end
  end
end

# TODO: for testing, delete later
=begin
require './lib/weather/decorator'
d = Weather::Decorator.new('lviv')
=end
