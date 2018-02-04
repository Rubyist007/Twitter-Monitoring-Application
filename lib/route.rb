class Route
  attr_accessor :controllers, :current_name

  def initialize
    self.controllers = {}
  end
  
  def draw(&map)
    instance_eval(&map.call)

    self.controllers
  end

  def controller(name)
    controllers[name] = {}
    self.current_name = name
    yield if block_given?
  end

  def get(path, method_name = nil)
    build_route(path, :GET, method_name, 'index')
  end

  def post(path, method_name = nil)
    build_route(path, :POST, method_name, 'create')
  end

  def delete(path, method_name = nil)
    build_route(path, :DELETE, method_name, 'destroy')
  end

  def build_route(path, request_method, method_name, default_method_name)
    path = path.to_sym
    method = method_name || parse_path(path) || default_method_name
    return controllers[current_name][path] = { request_method => method } if controllers[current_name][path].nil?
    controllers[current_name][path].store(request_method, method)
  end

  def parse_path(path)
    result = /(\w+)/.match(path)
    return if result.nil?
    result.captures[0]
  end
end
