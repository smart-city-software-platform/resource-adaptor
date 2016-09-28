require 'rest-client'
require 'json'

module ComponentServices
  module BusLine 

		def auth
			# token API olho vivo
			token = 'fd156f3011d240eb80d9b3c82cd1451ee8fe2a84664a03189f2a6ceb21d2cafe'
			response = RestClient.post("http://api.olhovivo.sptrans.com.br/v0/Login/Autenticar?token=#{token}", {})
			response.cookies['apiCredentials']
		end
    
		def collect_current_buses
      code = self.current_data['info_code']
			buses = {}

			begin
				buses = JSON.parse(RestClient.get("http://api.olhovivo.sptrans.com.br/v0/Posicao?codigoLinha=#{code}", {cookies: {"apiCredentials": self.auth}}).body)
			rescue
				return self.current_data['current_buses']
			end

			buses['vs'].each do |bus|
				component = Component.where(external_id: bus['p']).first	
				if component.blank?
					component = Component.create(lat: bus['py'], lon: bus['px'], collect_interval: 40, service_type: "Bus", capabilities: ['location', 'info_code'], external_id: bus['p'])
					component.last_collection['info_code'] = bus['p']
				end
				component.last_collection['location'] = [bus['py'], bus['px']]
				component.save!
			end

			buses['vs'].count
    end

    def collect_info_code
      self.current_data['info_code']
    end

  end

	module Bus
		def collect_location
			self.current_data['location']
		end

		def collect_info_code
			self.current_data['info_code']
		end
	end
end
