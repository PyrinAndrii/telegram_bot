# frozen_string_literal: true

module Weather
  class Decorator
    extend Forwardable

    attr_reader :city

    def initialize(city)
      @city = city
    end

    def tell_current_weather(parsed_response)
      current = parsed_response.current_weather

      "Now in #{city} is #{current.temp}°C, but feels like #{current.feels_like}°C. " \
        "Also now is #{current.description}"
    end

    def tell_weather_forecast(parsed_response)
      per_day = PerDayParser.new(parsed_response.forecast_list)
                            .average_weather_per_day

      text = per_day.map do |day, weather|
        "#{day} in #{city} will be #{weather.temp}°C, but feels like #{weather.feels_like}°C. " \
          "Also there will be #{weather.description}"
      end.join("\n")

      return message_to_long if text.length >= MAX_MESSAGE_LENGTH

      text
    end

    def message_to_long
      'Sorry message is too long'
    end
  end
end
