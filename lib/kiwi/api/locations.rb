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
      end

      %I[
        station airport bus_station city autonomous_territory subdivision
        country region continent
      ].each do |meth|
        define_method meth do |arg, **params|
          response = @conn.get(
            PATH,
            @default_params.merge(**params, location_types: meth, term: arg)
          )

          wrap_response(response).locations
        end
      end
    end
  end
end
