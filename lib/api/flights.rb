module Kiwi
  # rubocop:disable Metrics/ModuleLength
  module API
    # rubocop:disable Metrics/BlockLength
    FLIGHTS_PARAM_CONVERTER = ParameterConverter.new do
      convert(:version) do |v|
        { v: v }
      end

      convert(:currency) do |v|
        { curr: v }
      end

      convert(:from) do |v|
        { flyFrom: [*v].join(',') }
      end

      convert(:to) do |v|
        { to: [*v].join(',') }
      end

      convert(:depart) do |v|
        %I[dateFrom dateTo].zip(date_range(v)).to_h
      end

      convert(:return) do |v|
        %I[returnFrom returnTo].zip(date_range(v)).to_h
      end

      convert(:depart_takeoff) do |v|
        %I[dtimefrom dtimeto].zip(maybe_range(v)).to_h
      end

      convert(:depart_land) do |v|
        %I[atimefrom atimeto].zip(maybe_range(v)).to_h
      end

      convert(:return_takeoff) do |v|
        %I[returndtimefrom returndtimeto].zip(maybe_range(v)).to_h
      end

      convert(:return_land) do |v|
        %I[returnatimefrom returnatimeto].zip(maybe_range(v)).to_h
      end

      convert(:nights) do |v|
        %I[daysInDestinationFrom daysInDestinationTo].zip(maybe_range(v)).to_h
      end

      convert(:max_flight_time) do |v|
        { maxFlyDuration: v }
      end

      convert(:unique_cities) do |v|
        { oneforcity: bool_to_int(v) }
      end

      convert(:unique_dates) do |v|
        { one_per_date: bool_to_int(v) }
      end

      convert(:passengers) do |v|
        v
      end

      convert(:depart_days) do |v|
        params = { flyDaysType: 'departure' }

        next params.merge(flyDays: [1, 2, 3, 4, 5]) if v == :weekdays
        next params.merge(flyDays: [0, 6]) if v == :weekends

        params.merge(flyDays: v.map(&day_number))
      end

      convert(:return_days) do |v|
        params = { returnFlyDaysType: 'departure' }

        next params.merge(returnFlyDays: [1, 2, 3, 4, 5]) if v == :weekdays
        next params.merge(returnFlyDays: [0, 6]) if v == :weekends

        params.merge(returnFlyDays: v.map(&day_number))
      end

      convert(:price) do |v|
        %I[priceFrom priceTo].zip(maybe_range(v)).to_h
      end

      convert(:direct) do |v|
        { directFlights: bool_to_int(v) }
      end

      convert(:stopover_length) do |v|
        %I[stopoverfrom stopoverto].zip(maybe_range(v)).to_h
      end

      convert(:max_stopovers) do |v|
        { maxstopovers: v }
      end

      convert(:multi_airport) do |v|
        { connectionsOnDifferentAirport: bool_to_int(v) }
      end

      convert(:return_from_same) do |v|
        { returnFromDifferentAirport: bool_to_int(v) }
      end

      convert(:return_to_same) do |v|
        { returnToDifferentAirport: bool_to_int(v) }
      end

      convert(:include_airlines) do |v|
        {
          selectedAirlines: [*v].join(','),
          selectedAirlinesExclude: 0
        }
      end

      convert(:exclude_airlines) do |v|
        {
          selectedAirlines: [*v].join(','),
          selectedAirlinesExclude: 1
        }
      end

      convert(:include_stopovers) do |v|
        {
          selectedStopoverAirports: [*v].join(','),
          selectedStopoverAirportsExclude: 0
        }
      end

      convert(:exclude_stopovers) do |v|
        {
          selectedStopoverAirports: [*v].join(','),
          selectedStopoverAirportsExclude: 1
        }
      end

      convert(:ascending) do |v|
        { asc: bool_to_int(v) }
      end

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
    # rubocop:enable Metrics/BlockLength

    private_constant :FLIGHTS_PARAM_CONVERTER

    class Flights < Base
      PATH = '/flights'.freeze

      def initialize(params = {})
        @default_params = {
          version: 3,
          partner: 'picky',
          currency: 'USD',
          locale: 'en-US'
        }.merge(params)

        @param_converter = FLIGHTS_PARAM_CONVERTER

        super()
      end

      def search(params)
        request_params =
          @param_converter.process(@default_params.merge(params))

        response = @conn.get(PATH, request_params)

        wrap_response(response)
      end
    end
  end
  # rubocop:enable Metrics/ModuleLength
end
