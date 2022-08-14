# frozen_string_literal: true

module Weather
  module API
    class WeatherForecast < Base
      FORECAST_WEATHER_URL = 'api.openweathermap.org/data/2.5/forecast'

      def initialize(city)
        @request_url = FORECAST_WEATHER_URL
        super(city)
      end
    end
  end
end
