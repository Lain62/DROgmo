module Drogmo
    class LevelTileLayer
        attr_reader :sprites, :name, :eid, :offset_x, :offset_y, :grid_cell_width, :grid_cell_height
        attr_reader :grid_cells_x, :grid_cells_y, :tileset, :data, :export_mode, :array_mode
        def initialize(project_data, raw_data)
            @tileset = nil
            @exported_data = nil
            @sprites = []

            @name = raw_data["name"]
            @eid = raw_data["_eid"]
            @offset_x = raw_data["offsetX"]
            @offset_y = raw_data["offsetY"]
            @grid_cell_width = raw_data["gridCellWidth"]
            @grid_cell_height = raw_data["gridCellHeight"]
            @grid_cells_x = raw_data["gridCellsX"]
            @grid_cells_y = raw_data["gridCellsY"]
            @data = raw_data["data"]
            @export_mode = raw_data["exportMode"]
            @array_mode = raw_data["arrayMode"]

            project_data.tilesets.each do |tileset|
                if tileset.label == raw_data["tileset"]
                    @tileset = tileset
                end
            end

            project_data.layers.each do |layer|
                if layer[1].export_id == @eid
                    @exported_data = layer[1]
                end
            end

            setup
        end

        def setup
            cellY = @grid_cells_y
            cellX = 0
            @data.each do |tile|
                cellX += 1
                    if cellX > @grid_cells_x
                        cellY -= 1
                        cellX -= @grid_cells_y
                    end
                if tile == -1
                else
                    tiles = @tileset.tiles[tile]
                    @sprites << {
                        x: cellX * @grid_cell_width,
                        y: cellY * @grid_cell_height,
                        w: @grid_cell_width,
                        h: @grid_cell_height,
                        primitive_marker: :sprite,
                        path: tiles.path,
                        tile_x: tiles.tile_x,
                        tile_y: tiles.tile_y,
                        tile_w: tiles.tile_w,
                        tile_h: tiles.tile_h
                    }
                end
            end
        end
    end
end