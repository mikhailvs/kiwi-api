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

      private

      def date_range(val)
        from, to = maybe_range(val)

        if from.is_a?(Date)
          [from.strftime('%d/%m/%Y'), to.strftime('%d/%m/%Y')]
        else
          [from, to]
        end
      end

      def maybe_range(val)
        val.is_a?(Range) ? [val.first, val.last] : [val, val]
      end

      def bool_to_int(val)
        val ? 1 : 0
      end

      def day_number(day_name)
        %I[sun mon tue wed thu fri sat].index(day_name)
      end
    end
  end
end
