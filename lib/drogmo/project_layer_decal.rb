module Drogmo
    class ProjectLayerDecal
        attr_reader :definition, :name, :grid_size, :export_id, :folder, :include_image_sequence, :scaleable, :rotatable, :values
        def initialize(data_raw)
            @definition = data_raw["definition"]
            @name = data_raw["name"]
            @grid_size = [data_raw["gridSize"]["x"], data_raw["gridSize"]["y"]]
            @export_id = data_raw["exportID"]
            @folder = data_raw["folder"]
            @include_image_sequence = data_raw["includeImageSequence"]
            @scaleable = data_raw["scaleable"]
            @rotatable = data_raw["rotatable"]
            @values = data_raw["values"]
        end
    end
end