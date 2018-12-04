module Kiwi
  module API
    # rubocop:disable Metrics/BlockLength
    FLIGHTS_PARAM_CONVERTER = ParameterConverter.new do
      convert(:version) { |v| { v: v } }
      convert(:currency) { |v| { curr: v } }
      convert(:from) { |v| { fly_from: [*v].join(',') } }
      convert(:to) { |v| { fly_to: [*v].join(',') } }
      convert(:depart) { |v| %I[date_from date_to].zip(date_range(v)).to_h }
      convert(:return) { |v| %I[return_from return_to].zip(date_range(v)).to_h }
      convert(:max_flight_time) { |v| { max_fly_duration: v } }
      convert(:unique_cities) { |v| { one_for_city: bool_to_int(v) } }
      convert(:unique_dates) { |v| { one_per_date: bool_to_int(v) } }
      convert(:passengers) { |v| v }
      convert(:price) { |v| %I[price_from price_to].zip(maybe_range(v)).to_h }
      convert(:direct) { |v| { direct_flights: bool_to_int(v) } }
      convert(:max_stopovers) { |v| { max_stopovers: v } }
      convert(:ascending) { |v| { asc: bool_to_int(v) } }

      convert(:depart_takeoff) do |v|
        %I[dtime_from dtime_to].zip(maybe_range(v)).to_h
      end

      convert(:depart_land) do |v|
        %I[atime_from atime_to].zip(maybe_range(v)).to_h
      end

      convert(:return_takeoff) do |v|
        %I[ret_dtime_from ret_dtime_to].zip(maybe_range(v)).to_h
      end

      convert(:return_land) do |v|
        %I[ret_atime_from ret_atime_to].zip(maybe_range(v)).to_h
      end

      convert(:nights) do |v|
        %I[nights_in_dst_from nights_in_dst_to].zip(maybe_range(v)).to_h
      end

      convert(:depart_days) do |v|
        params = { fly_days_type: 'departure' }

        next params.merge(fly_days: [1, 2, 3, 4, 5]) if v == :weekdays
        next params.merge(fly_days: [0, 6]) if v == :weekends

        params.merge(fly_days: v.map(&day_number))
      end

      convert(:return_days) do |v|
        params = { ret_fly_days_type: 'arrival' }

        next params.merge(ret_fly_days: [1, 2, 3, 4, 5]) if v == :weekdays
        next params.merge(ret_fly_days: [0, 6]) if v == :weekends

        params.merge(ret_fly_days: v.map(&day_number))
      end

      convert(:stopover_length) do |v|
        %I[stopover_from stopover_to].zip(maybe_range(v)).to_h
      end

      convert(:multi_airport) do |v|
        { conn_on_diff_airport: bool_to_int(v) }
      end

      convert(:return_from_same) do |v|
        { ret_from_diff_airport: bool_to_int(v) }
      end

      convert(:return_to_same) do |v|
        { ret_to_diff_airport: bool_to_int(v) }
      end

      convert(:include_airlines) do |v|
        {
          select_airlines: [*v].join(','),
          select_airlines_exclude: 0
        }
      end

      convert(:exclude_airlines) do |v|
        {
          selectedAirlines: [*v].join(','),
          select_airlines_exclude: 1
        }
      end

      convert(:include_stopovers) do |v|
        {
          select_stop_airport: [*v].join(','),
          select_stop_airport_exclude: 0
        }
      end

      convert(:exclude_stopovers) do |v|
        {
          select_stop_airport: [*v].join(','),
          select_stop_airport_exclude: 1
        }
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

        puts request_params.inspect

        response = @conn.get(PATH, request_params)

        wrap_response(response)
      end
    end
  end
end
