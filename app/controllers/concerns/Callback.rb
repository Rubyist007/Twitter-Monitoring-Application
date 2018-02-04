require 'rack'

module Callbacks
  def before(*names)
    names.each do |name|
      m = self.class.instance_method(name)
      define_singleton_method(name) do |*args, &block|
        yield
        m.bind(self).(*args, &block)
      end
    end
  end

  def authenticate!(*names) 
    names.each do |name|
      m = self.class.instance_method(name)
      define_singleton_method(name) do |*args, &block|
        if request.session['user'] != nil
          m.bind(self).(*args, &block)
        else
          response = Rack::Response.new      
          response.redirect('/user/sign_in')
          response.finish
        end
      end
    end
  end
end
