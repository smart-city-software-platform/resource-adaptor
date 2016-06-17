module ComponentServices
  module HealthFacility
    def collect_info_total_capacity
      self.last_collection['info_total_capacity']
    end

    def collect_info_facility_type
      self.last_collection['info_facility_type']
    end

    def collect_current_users
      Random.rand(0...(2 * collect_info_total_capacity))
    end
  end
end
