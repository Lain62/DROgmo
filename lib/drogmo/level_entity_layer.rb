module Drogmo
    class LevelEntityLayer
        attr_reader :name, :eid, :offset_x, :offset_y, :grid_cell_width, :grid_cell_height, :grid_cells_x, :grid_cells_y
        attr_reader :entities
        def initialize(project, data)
            @name = data["name"]
            @eid = data["_eid"]
            @offset_x = data["offsetX"]
            @offset_y = data["offsetY"]
            @grid_cell_width = data["gridCellWidth"]
            @grid_cell_height = data["gridCellHeight"]
            @grid_cells_x = data["gridCellsX"]
            @grid_cells_y = data["gridCellsY"]
            @entities = []

            data["entities"].each do |entity|
                import_data = project.entities[entity["name"]]
                @entities << {
                    name: entity["name"],
                    id: entity["id"],
                    eid: entity["_eid"],
                    x: entity["x"],
                    y: entity["y"],
                    origin_x: entity["originX"],
                    origin_y: entity["originY"],
                    values: entity["values"],
                    data: import_data
                }
            end
        end
    end
end