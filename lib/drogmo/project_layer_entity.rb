module Drogmo
    class ProjectLayerEntity
        attr_reader :definition, :name, :grid_size, :export_id, :required_tags, :excluded_tags
        def initialize(data_raw)
            @definition = data_raw["definition"]
            @name = data_raw["name"]
            @grid_size = [data_raw["gridSize"]["x"], data_raw["gridSize"]["y"]]
            @export_id = data_raw["exportID"]
            @required_tags = data_raw["requiredTags"]
            @excluded_tags = data_raw["excludedTags"]
        end
    end
end