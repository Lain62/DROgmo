module Drogmo
    class Level
        attr_reader :data_raw, :layers
        def initialize(ogmo_data, path)
            @ogmo_data = ogmo_data
            @data_raw = $gtk.parse_json_file(path)
            @layers = {}
            setup
        end

        def setup
            # @data_raw[:children].each do |attribute|
            #     # puts attribute
            # end
            @data_raw.each_pair do |attribute|
                case attribute[0]
                when "layers"
                    attribute[1].each do |layer|
                        case @ogmo_data.layers["#{layer["name"]}"].definition
                        when "tile"
                            @layers["#{layer["name"]}"] = LevelTileLayer.new(@ogmo_data, layer)
                        when "entity"
                            @layers["#{layer["name"]}"] = LevelEntityLayer.new(@ogmo_data, layer)
                        end
                    end
                end
            end
        end
    
        def sprites

        end
  
    end
  end