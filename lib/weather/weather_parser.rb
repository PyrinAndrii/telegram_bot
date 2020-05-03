require_relative 'presenters/main'
require_relative 'presenters/weather'

require 'forwardable'
require 'date'

module Weather
  class WeatherParser
    extend Forwardable

    CURRENT_WEATHER  = 'Current weather'
    WEATHER_FORECAST = 'Weather forecast'

    attr_reader :type, :date_time, :wind, :parsed_weather, :parsed_main_data

    def_delegators :parsed_weather,   :main, :description
    def_delegators :parsed_main_data, :temp, :temp_min, :temp_max, :feels_like

    def initialize(weather_data)
      @wind = weather_data.dig(:wind, :speed).to_f

      @parsed_main_data = Presenters::Main.new(weather_data.dig(:main))
      @parsed_weather   = Presenters::Weather.new(weather_data.dig(:weather))

      additional_info(weather_data.dig(:dt_txt))
    end

    def additional_info(dt_txt)
      @type      = dt_txt ? WEATHER_FORECAST : CURRENT_WEATHER
      @date_time = dt_txt ? DateTime.parse(dt_txt) : Time.now
    end
  end
end
