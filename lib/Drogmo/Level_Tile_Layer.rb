module Drogmo
    class LevelTileLayer
        attr_reader :sprites
        def initialize(project_data, data)
            @project_data = project_data
            @tileset = nil
            @raw_data = data
            @sprites = []
            setup
        end

        def setup
            @project_data.tilesets.each do |tileset|
                if tileset.name == @raw_data["tileset"]
                    @tileset = tileset
                end
            end

            cellY = @raw_data["gridCellsY"]
            cellX = 0
            @raw_data["data"].each do |tile|
                cellX += 1
                    if cellX > @raw_data["gridCellsX"]
                        cellY -= 1
                        cellX -= @raw_data["gridCellsX"]
                    end
                if tile == -1
                else
                    tiles = @tileset.tiles[tile]
                    @sprites << {
                        x: cellX * @raw_data["gridCellWidth"],
                        y: cellY * @raw_data["gridCellHeight"],
                        w: @raw_data["gridCellWidth"],
                        h: @raw_data["gridCellHeight"],
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