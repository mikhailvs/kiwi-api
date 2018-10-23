module Kiwi
  module API
    class WrappedResponse
      def initialize(obj)
        @obj = obj
      end

      # rubocop:disable Style/MethodMissingSuper
      def method_missing(meh, *arr, &blk)
        val = @obj.dig(meh.to_s)

        return val.map(&self.class.method(:new)) if val.is_a?(Array)

        return self.class.new(val) if val.is_a?(Hash)

        return @obj.send(meh, *arr, &blk) if val.nil? && @obj.respond_to?(meh)

        val
      end
      # rubocop:enable Style/MethodMissingSuper

      def respond_to_missing?(method_name, *_args, &_block)
        !@obj.dig(method_name.to_s).nil? || @obj.respond_to?(method_name)
      end

      def unwrap
        @obj
      end
    end
  end
end
