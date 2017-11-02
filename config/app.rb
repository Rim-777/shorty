require './config/environment'

OTR::ActiveRecord.configure_from_file! Config.root.join('config', 'database.yml')

[
    %w(app api v* *.rb),
    %w(app models ** *.rb),
    %w(app services ** *.rb)

].each do |folder|
  Dir.glob(Config.root.join(*folder)).each {|file| require file}
end
