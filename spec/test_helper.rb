require_relative 'support/factory_bot'

ENV['RACK_ENV'] = 'test'

db_config = YAML.load(File.read( "config/database.yml" ))
ActiveRecord::Base.establish_connection( db_config[ ENV[ 'RACK_ENV' ]])

