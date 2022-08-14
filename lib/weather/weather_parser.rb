# frozen_string_literal: true

module Weather
  class WeatherParser
    extend Forwardable

    attr_reader :type, :date_time, :wind, :parsed_weather, :parsed_main_data

    def_delegators :parsed_weather,   :main, :description
    def_delegators :parsed_main_data, :temp, :temp_min, :temp_max, :feels_like

    def initialize(weather_data)
      @wind = weather_data.dig(:wind, :speed).to_f

      @parsed_main_data = Presenters::Main.new(weather_data[:main])
      @parsed_weather   = Presenters::Weather.new(weather_data[:weather])

      additional_info(weather_data[:dt_txt])
    end

    def additional_info(dt_txt)
      @type      = dt_txt ? WEATHER_FORECAST : CURRENT_WEATHER
      @date_time = dt_txt ? DateTime.parse(dt_txt) : Time.now
    end
  end
end
