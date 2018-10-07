module Kiwi
  module API
    class WrappedResponse
      def initialize(obj)
        @obj = obj
      end

      # rubocop:disable Style/MethodMissingSuper
      def method_missing(method_name, *args, &block)
        val = @obj.dig(method_name.to_s)

        return val.map(&self.class.method(:new)) if val.is_a?(Array)

        return self.class.new(val) if val.is_a?(Hash)

        return @obj.send(method_name, *args, &block) if val.nil?

        val
      end
      # rubocop:enable Style/MethodMissingSuper

      def respond_to_missing?(method_name)
        !@obj.dig(method_name.to_s).nil? || @obj.respond_to?(method_name)
      end

      def unwrap
        @obj
      end
    end
  end
end
