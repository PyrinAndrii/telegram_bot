require 'dotenv/load'
require_relative './lib/weather/decorator'
require_relative 'telegram_bot'

TelegramBot.new.run
