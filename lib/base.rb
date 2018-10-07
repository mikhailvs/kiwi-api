module Kiwi
  module API
    class Base
      BASE_URL = 'https://api.skypicker.com'.freeze

      attr_reader :conn

      def initialize(connection: Faraday.new(url: BASE_URL))
        @conn = connection
      end

      def wrap_response(response)
        json = JSON.parse(response.body)

        case json
        when Array
          json.map(&WrappedResponse.method(:new))
        else
          WrappedResponse.new(json)
        end
      end
    end

    private_constant :Base
  end
end
