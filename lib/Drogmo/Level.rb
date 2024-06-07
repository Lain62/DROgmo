module Drogmo
    class Level
        attr_reader :data_raw
        def initialize(ogmo_data, path)
            @ogmo_data = ogmo_data
            @data_raw = $gtk.parse_json_file(path)
            setup
        end

        def setup
            # @data_raw[:children].each do |attribute|
            #     # puts attribute
            # end
        end
    
        def sprites

        end
  
    end
  end