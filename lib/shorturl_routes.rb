
require 'shorturl_routes/routing'

ActionDispatch::Routing::Mapper.send :include, ShorturlRoutes::Routing::MapperExtensions

class ::ActionDispatch::Routing::Mapper::Constraints
  alias_method :old_matches?, :matches?
  def new_matches?(env)
    req = @request.new(env)

    @constraints.each { |constraint|
      if constraint.respond_to?(:matches?) && !constraint.matches?(req)
        return false
      elsif constraint.respond_to?(:call) && !constraint.call(*constraint_args(constraint, req))
        return false
      end
    }

    l = @constraints.last
    if l.respond_to?(:matches?)
      x = l.matches?(*constraint_args(l, req))
      env["action_dispatch.request.path_parameters"][:id] = x.id if x.is_a?(ActiveRecord::Base)
    end

    return true
  end
  alias_method :matches?, :new_matches?
end
