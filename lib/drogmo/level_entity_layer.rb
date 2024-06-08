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
                width = @grid_cell_width
                height = @grid_cell_height
                flipped_x = nil
                flipped_y = nil
                rotation = 0

                rotation = entity["rotation"] if entity["rotation"] != nil

                width = entity["width"] if entity["width"] != nil
                height = entity["height"] if entity["height"] != nil

                flipped_x = entity["flippedX"] if entity["flippedX"] != nil
                flipped_y = entity["flippedY"] if entity["flippedY"] != nil

                import_data = project.entities[entity["name"]]
                @entities << {
                    name: entity["name"],
                    id: entity["id"],
                    eid: entity["_eid"],
                    x: entity["x"],
                    y: level_data.height - entity["y"] - height,  # Weird formula to compensate for the origin point being in the top left
                    origin_x: entity["originX"],
                    origin_y: entity["originY"],
                    values: entity["values"],
                    width: width,
                    height: height,
                    flipped_x: flipped_x,
                    flipped_y: flipped_y,
                    rotation: rotation,
                    data: import_data
                }
            end
        end
    end
end