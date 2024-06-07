module Drogmo
    class ProjectLayer
        attr_reader :definition, :name, :grid_size, :export_id, :export_mode, :array_mode, :default_tileset
        def initialize(data_raw)
            @definition = data_raw["definition"]
            @name = data_raw["name"]
            @grid_size = [data_raw["gridSize"]["x"], data_raw["gridSize"]["y"]]
            @export_id = data_raw["exportID"]
            @export_mode = data_raw["exportMode"]
            @array_mode = data_raw["arrayMode"]
            @default_tileset = data_raw["defaultTileset"]
        end
    end
end