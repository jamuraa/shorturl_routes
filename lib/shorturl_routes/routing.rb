module ShorturlRoutes
  module Routing
    module MapperExtensions
      def shorturl(path, options = nil)
        if !options.has_key?(:model) or !options.has_key?(:to) or !options.has_key?(:attribute)
          raise ArgumentError, "shorturl needs :model, :to, and :attribute."
        end
        Kernel.const_get(options[:model]) # make sure the model exists.
        s = lambda {|x| Kernel.const_get(options[:model]).where(options[:attribute] => x.symbolized_path_parameters[options[:attribute]]).first }
        constraints(s) do
          match path, :to => options[:to]
        end
      end
    end
  end
end
