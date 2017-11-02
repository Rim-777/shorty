require './config/environment'

OTR::ActiveRecord.configure_from_file! Config.root.join('config', 'database.yml')

