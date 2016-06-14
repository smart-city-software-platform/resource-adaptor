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
      SPOT_STATUSES.values.sample
    end
  end
end
