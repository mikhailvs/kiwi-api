module Kiwi
  module API
    class Locations < Base
      PATH = '/locations'.freeze

      def initialize
        super

        @default_params = {
          locale: 'en-US',
          active_only: true
        }

        @conn.options[:params_encoder] = Faraday::FlatParamsEncoder
      end

      %I[
        station airport bus_station city autonomous_territory subdivision
        country region continent
      ].each do |meth|
        define_method meth do |arg, **params|
          search(arg, params.merge(location_types: meth))
        end
      end

      def search(term, **params)
        response = @conn.get(
          PATH,
          @default_params.merge(**params, term: term)
        )

        wrap_response(response).locations
      end
    end
  end
end
