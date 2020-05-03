require_relative 'response_parser'
require_relative 'api/current_weather'
require_relative 'api/weather_forecast'

module Weather
  class Decorator
    extend Forwardable

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

      # TODO: implement better weather forecast, not so long!!!
      # parsed_response.forecast_list.map do |w|
      parsed_response.forecast_list.first(3).map do |w|
        "#{w.date_time} in #{city} will be #{w.temp}°C, but feels like #{w.feels_like}°C. "\
        "Also there will be #{w.description}"
      end.join("\n")
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
  end
end

# TODO: for testing, delete later
=begin
require './lib/weather/decorator'
d = Weather::Decorator.new('lviv')
=end
