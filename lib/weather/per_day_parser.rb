module Weather
  class PerDayParser
    attr_accessor :weather_per_day, :average_weather_per_day
    attr_reader :weather_list

    TO_DAY_OF_THE_WEEK = '%A'

    def initialize(weather_list)
      @weather_list = weather_list
      @weather_per_day = {}
      @average_weather_per_day = {}

      parse_weather_per_day
      calculate_average_weather_per_day
    end

    def parse_weather_per_day
      weather_list.each do |item|
        day = item.date_time.strftime(TO_DAY_OF_THE_WEEK).downcase.to_sym
        weather_per_day[day] ||= []

        weather_per_day[day] << item
      end
    end

    def calculate_average_weather_per_day
      weather_per_day.each do |day, weather|
        average_weather_per_day[day] = average_per_day(weather)
      end
    end

    def average_per_day(weather)
      # TODO: add calculation of weather per day
      weather.first
    end
  end
end
