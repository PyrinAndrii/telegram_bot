# frozen_string_literal: true

module Weather
  class ResponseParser
    attr_reader :cod, :current_weather, :forecast_list, :error

    def initialize(resp)
      @response = JSON.parse(resp, symbolize_names: true)
      @cod = response[:cod].to_i

      parse_response(resp)
    end

    def parse_response(_resp)
      success? ? parse_data : error_message
    end

    def success?
      cod == SUCCESS_RESPONSE_CODE
    end

    def failure?
      cod != SUCCESS_RESPONSE_CODE
    end

    private

    attr_reader :response

    def parse_data
      text_list = response[:list]
      return parse_current_weather unless text_list

      @forecast_list = text_list.map { |item| parse_item(item) }
    end

    def parse_current_weather
      @current_weather = WeatherParser.new(response)
    end

    def parse_item(item)
      WeatherParser.new(item)
    end

    def error_message
      @error = response[:message]
    end
  end
end
