require './app/controllers/user_controller.rb'
require './app/controllers/twitter_controller.rb'
require './config/routes.rb'
require './lib/route.rb'
require 'yaml'
require 'active_record'

class TwitterMonitoringApplication
  
  attr_accessor :routes, :user_controller, :twitter_controller

  def initialize
    connect_to_db 
  end

  def call(env)
    request = Rack::Request.new(env) 
    init_variables(request)
    processing_request(request) 
  end

  def processing_request(request)
    action = find_action(request.path_info, request.request_method) 
    run_action(action, request.params)
  #rescue
  #  f = File.open("./app/views/error/404.html")
  #  ['200', {'Content-Type' => 'text/html'}, [f.read]] 
  end

  private

    def find_action(request_path, request_method)
      scaned_path = request_path.scan(/(\w+)/)
      return if scaned_path.nil?
      scaned_path << '/' if scaned_path.length == 1
      scaned_path << request_method
      keys_to_callable_method = scaned_path.flatten.map { |e| e.to_sym }
      
      { name_controller: keys_to_callable_method[0].to_s, 
        method_controller: routes.dig(*keys_to_callable_method) }   
    end

    def run_action(action, params)
      return self.send("#{action[:name_controller]}_controller").send(action[:method_controller]) if params.empty?
      self.send("#{action[:name_controller]}_controller").send(action[:method_controller], params)
    end

    def connect_to_db
      db_config = YAML.load(File.open('./config/database.yml'))
      ActiveRecord::Base.establish_connection(db_config)
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end 

    def init_variables(request)
      self.user_controller = UserController.new(request)
      self.twitter_controller = TwitterController.new(request)
      self.routes = Route.new.draw { APP_ROUTES } 
    end
end
