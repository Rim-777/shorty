require './config/app'

use OTR::ActiveRecord::ConnectionManagement

run Api::V1::Links
