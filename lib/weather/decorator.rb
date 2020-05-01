require_relative 'response_parser'
require_relative 'api/current_weather'

module Weather
  class Decorator
    extend Forwardable

    attr_reader :city, :parsed_response

    def_delegators :parsed_weather,   :main, :description
    def_delegators :parsed_response,  :cod, :message
    def_delegators :parsed_main_data, :temp, :temp_min, :temp_max, :feels_like

    def initialize(city)
      @city = city
      response = API::CurrentWeather.new(city).response
      @parsed_response = ResponseParser.new(response.body)
    end

    def tell_current_weather
      return message unless cod == ResponseParser::SUCCESS_RESPONSE_CODE

      "Now in #{city} is #{temp}°C, but feels like #{feels_like}°C. "\
      "Also now is #{description}"
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
