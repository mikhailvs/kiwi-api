module Kiwi
  module API
    class ParameterConverter
      def initialize(&block)
        @converters = {}

        instance_eval(&block)
      end

      def convert(name, &block)
        @converters.merge!(name => block)
      end

      def process(params)
        params.reduce({}) do |res, (key, val)|
          next res.merge!(key => val) if @converters[key].nil?

          res.merge!(@converters[key].call(val))
        end
      end
    end

    private_constant :ParameterConverter
  end
end
