require './app/controllers/concerns/Callback.rb'

class BaseController
  attr_accessor :request, :current_user

  include Callbacks 

  private

    def initialize(request)
      self.current_user = set_current_user(request.session['user'])
      self.request = request
    end

    def redirect_to(path)
      response = Rack::Response.new      
      response.redirect(path)
      response.finish
    end

    def render(name)
      layout = File.open("./app/views/layout/application.html.erb").read

      if block_given?
        tamplate = make_erb(File.open("./app/views/#{name}.html.erb").read) { yield }

      else
         tamplate = File.open("./app/views/#{name}.html").read       
      end

      page = make_page(layout) { tamplate }
      ['200', {'Content-Type' => 'text/html'}, [page]]
    end 

    def render_json(json)
      [200, { 'Content-Type' => 'application/json' }, [json]]
    end

    def make_erb(tamplate)
      yield
      ERB.new(tamplate).result(binding)
    end

    def make_page(layout)
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
