require './config/app'

use OTR::ActiveRecord::ConnectionManagement

use Rack::Static,
    root: File.expand_path('../swagger-ui', __FILE__),
    urls: ["/css","/fonts","/images","/lang","/lib"],
    index: 'index.html'

run Api::V1::Links
