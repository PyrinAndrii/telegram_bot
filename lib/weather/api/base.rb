# frozen_string_literal: true

module Weather
  module API
    class Base
      APPID = ENV.fetch('OPEN_WEATHER_MAP_API_TOKEN')

      attr_reader :city, :request_url, :response

      def initialize(city)
        @city = city
        @response = make_request
      end

      def make_request
        params = { q: city, APPID: APPID, units: :metric }

        begin
          RestClient.get(request_url, params:)
        rescue RestClient::ExceptionWithResponse => e
          e.response
        end
      end
    end
  end
end
