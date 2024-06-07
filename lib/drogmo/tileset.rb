module Drogmo
    class Tileset
        attr_reader :name, :data_raw, :tiles, :tile_separation, :tile_margin, :tile_size, :path, :size
        def initialize(tileset_data, path_relative)
           
            @data_raw = tileset_data
            @path_relative = path_relative
            @name = @data_raw["label"]
            @path = "#{@path_relative}#{@data_raw["path"]}"
            @tile_size = [@data_raw["tileWidth"], @data_raw["tileHeight"]]
            @tile_separation = [@data_raw["tileSeparationX"], @data_raw["tileSeparationY"]]
            @tile_margin = [@data_raw["tileMarginX"],@data_raw["tileMarginY"]]
            @size = $gtk.calcspritebox @path
            @tiles = []
            setup
        end

        def setup
            offset_x = @tile_margin.x
            offset_y = @tile_margin.y
            big_square_w = @tile_size.x + @tile_separation.x
            big_square_h = @tile_size.y + @tile_separation.y

            square = [(@size.x / big_square_w).to_i, (@size.y / big_square_h).to_i]
            square_tiles_amount = square.x * square.y

            cellX = 0
            cellY = 0
            for a in 1..square_tiles_amount
                
                @tiles << {
                    tile_w: @tile_size.x,
                    tile_h: @tile_size.y,
                    tile_x: cellX * @tile_size.x + @tile_separation.x + offset_x,
                    tile_y: cellY * @tile_size.y + @tile_separation.y + offset_y,
                    path: @path
                }
                cellX += 1
                if cellX > square.x
                    cellX -= square.x
                    cellY += 1
                end
            end
            puts @tiles
        end

    end
end