module Weather
  class ResponseParser
    SUCCESS_RESPONSE_CODE = 200

    attr_reader :cod, :current_weather, :forecast_list, :message

    def initialize(resp)
      response = JSON.parse(resp, symbolize_names: true)
      @cod = response.dig(:cod).to_i
      return error_message(response) unless cod == SUCCESS_RESPONSE_CODE

      parse_data(response)
    end

    def parse_data(response)
      text_list = response.dig(:list)

      return parse_current_weather(response) unless text_list

      @forecast_list = text_list.map { |item| parse_item(item) }
    end

    def parse_current_weather(response)
      @current_weather = WeatherParser.new(response)
    end

    def parse_item(item)
      WeatherParser.new(item)
    end

    def error_message(response)
      @message = response.dig(:message)
    end
  end
end
