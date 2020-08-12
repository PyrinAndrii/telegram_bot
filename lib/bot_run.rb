# additional ruby libraries
require 'forwardable'
require 'date'
require 'json'

# thir-party gems
require 'dotenv/load'
require 'rest-client'
require 'telegram/bot'
require 'pry'

# require all files
Dir[File.join(__dir__, 'weather', 'presenters', '*.rb')].each { |file| require file }
require File.join(__dir__, 'weather', 'api', 'base.rb')
Dir[File.join(__dir__, 'weather', 'api', '*.rb')].each { |file| require file }
Dir[File.join(__dir__, 'weather', '*.rb')].each { |file| require file }
require File.join(__dir__, 'common_constants')
require File.join(__dir__, 'telegram_bot')

# run the bot
TelegramBot.new.run
