module ComponentServices
  ##
  # Implement methods to read data from spot availability sensors.
  # Note: since we do not have access to a real parking data API,
  # all data in this module will be randomly generated.
  module ParkingSpot

    ##
    # Values that may be returned from the spot availability sensor.
    SPOT_STATUSES = { available: 0, occupied: 1 }

    ##
    # Simulate reading data from a sensor.
    # @return [Fixnum] a number indicating the spot availability.
    def collect_spot_availability
      now  = Time.now.utc
      wday = now.wday
      hnow = time_to_float(now.strftime('%H:%M'))

      # Check if the spot has parking restrictions applicable now.
      restrictions = collect_availability_schedules.reject do |a|
        start_at = time_to_float(a['begin_time'])
        end_at   = time_to_float(a['end_time'])

        # A spot CAN be available if:

        # The restriction says it's available, or...
        a['is_available'] ||

        # The current day is not covered by the restriction, or...
        wday < a['from'] || wday > a['to'] ||

        # The current time is not covered by the restriction.
        hnow < start_at || hnow > end_at
      end

      if restrictions.empty?
        SPOT_STATUSES.values.sample
      else
        SPOT_STATUSES[:available]
      end
    end

    ##
    # @return [Hash] The availability schedules for the spot.
    def collect_availability_schedules
      if last_collection['availability_schedules'].is_a?(String)
        JSON.load(last_collection['availability_schedules'])
      else
        last_collection['availability_schedules']
      end
    end

    private

    ##
    # @return [Float] A number in the [0, 24) interval representing the current
    #                 time, in decimal.
    # @example
    #   time_to_float('13:30') => 13.5
    #
    def time_to_float(str)
      hour, min = str.split(':')
      hour.to_i + min.to_f / 60
    end
  end
end
