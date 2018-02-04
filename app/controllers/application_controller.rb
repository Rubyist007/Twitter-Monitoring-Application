require './app/controllers/concerns/Callback.rb'

class BaseController
  attr_accessor :request, :client

  include Callbacks 

  private

    def redirect_to(path)
      response = Rack::Response.new      
      response.redirect(path)
      response.finish
    end

    def render(name)
      layout = File.open("./app/views/layout/application.html.erb").read
      tamplate = File.open("./app/views/#{name}.html").read
      page = make_erb(layout) { tamplate }
      ['200', {'Content-Type' => 'text/html'}, [page]]
    end 

    def render_json(json)
      [200, { 'Content-Type' => 'application/json' }, [json]]
    end

    def make_erb(layout)
      js = File.open("./app/assets/js/application.js").read
      ERB.new(layout).result(binding)
    end

    def set_current_user(user)
      if user.nil?
        nil
      else
        User.find(user[:id])
      end

    end

end
