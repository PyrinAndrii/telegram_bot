# frozen_string_literal: true

CURRENT_WEATHER  = 'Current weather'
WEATHER_FORECAST = 'Weather forecast'

SUCCESS_RESPONSE_CODE = 200
MAX_MESSAGE_LENGTH    = 4096

# match if command start with '/city', has a space and 1 or more letters
CITY_REGEXP = %r{^/city \w+}
