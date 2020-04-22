require_relative 'presenters/main'
require_relative 'presenters/weather'

require 'json'

module Weather
  class ResponseParser
    SUCCESS_RESPONSE_CODE = 200

    attr_reader :wind, :dt, :cod, :parsed_weather,
                :parsed_main_data, :message, :name

    def initialize(resp)
      response = JSON.parse(resp, symbolize_names: true)
      @cod = response.dig(:cod).to_i
      return error_message(response) unless cod == SUCCESS_RESPONSE_CODE

      parse_data(response)
    end

    def parse_data(response)
      @dt   = response.dig(:dt)
      @wind = response.dig(:wind, :speed)
      @name = response.dig(:name)
      @parsed_main_data = Presenters::Main.new(response.dig(:main))
      @parsed_weather   = Presenters::Weather.new(response.dig(:weather))
    end

    def error_message(response)
      @message = response.dig(:message)
    end
  end
end
