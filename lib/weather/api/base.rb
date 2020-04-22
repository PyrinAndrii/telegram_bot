# TODO: delete it later. Just for testing
require 'dotenv/load'

require 'rest-client'

module Weather
  module API
    class Base
      APPID = ENV['OPEN_WEATHER_MAP_API_TOKEN']

      attr_reader :city, :request_url, :response

      def initialize(city)
        @city = city
        @response = make_request
      end

      def make_request
        params = { q: city, APPID: APPID, units: :metric }

        begin
          RestClient.get(request_url, params: params)
        rescue RestClient::ExceptionWithResponse => error
          error.response
        end
      end
    end
  end
end
