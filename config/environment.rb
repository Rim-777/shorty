require 'ostruct'
require 'pathname'

Config = OpenStruct.new
Config.env = ENV['RACK_ENV'] ? ENV['RACK_ENV'].to_sym : :development
Config.root = Pathname.new(File.expand_path('../..', __FILE__))

require 'bundler'
Bundler.require(:default, Config.env)

