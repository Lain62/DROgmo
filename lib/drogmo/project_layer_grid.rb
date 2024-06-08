module Drogmo
    class ProjectLayerGrid
        attr_reader :definition, :name, :grid_size, :export_id, :array_mode
        attr_reader :legend, :legendRGBA
        def initialize(data_raw)
            @definition = data_raw["definition"]
            @name = data_raw["name"]
            @grid_size = [data_raw["gridSize"]["x"], data_raw["gridSize"]["y"]]
            @export_id = data_raw["exportID"]
            @array_mode = data_raw["arrayMode"]
            @legend = data_raw["legend"]
            @legendRGBA = {}
            @legend.each do |attribute|
                color_convert = attribute[1].gsub("#", "") 
                @legendRGBA[attribute[0]] = Drogmo.color(color_convert)
            end
        end
    end
end