module Drogmo
    class Level
        attr_reader :ogmo_version, :width, :height, :offset_x, :offset_y, :values, :layers
        def initialize(project_data, path)
            data = $gtk.parse_json_file(path)
            @ogmo_version = data["ogmoVersion"]
            @width = data["width"]
            @height = data["height"]
            @offset_x = data["offsetX"]
            @offset_y = data["offsetY"]
            @values = data["values"]
            @layers = {}

            data["layers"].each do |layer|
                case project_data.layers["#{layer["name"]}"].definition
                when "tile"
                    @layers["#{layer["name"]}"] = LevelTileLayer.new(project_data, layer)
                when "entity"
                    @layers["#{layer["name"]}"] = LevelEntityLayer.new(project_data, layer)
                when "grid"
                    @layers["#{layer["name"]}"] = LevelGridLayer.new(project_data, layer)
                end
            end
        end
    end
  end