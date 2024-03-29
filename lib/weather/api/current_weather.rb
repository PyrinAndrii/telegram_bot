# frozen_string_literal: true

module Weather
  module API
    class CurrentWeather < Base
      CURRENT_WEATHER_URL = 'api.openweathermap.org/data/2.5/weather'

      def initialize(city)
        @request_url = CURRENT_WEATHER_URL
        super(city)
      end
    end
  end
end
