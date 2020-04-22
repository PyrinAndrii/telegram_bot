module Weather
  module Presenters
    class Weather
      attr_accessor :main, :description

      def initialize(weather)
        parse_data(weather.first)
      end

      def parse_data(weather_data)
        @main        = weather_data[:main]
        @description = weather_data[:description]
      end
    end
  end
end
