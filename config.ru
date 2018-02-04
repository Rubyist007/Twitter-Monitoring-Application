require './app.rb'

app = Rack::Builder.app do
  use Rack::Reloader 
  use Rack::Session::Cookie, key: 'rack.session',
                             domain: 'localhost',
                             path: '/',
                             expire_after: 2592000,
                             secret: 'secter_value',
                             old_secret: 'old_secret_value'
 
  run TwitterMonitoringApplication.new
end

run app
