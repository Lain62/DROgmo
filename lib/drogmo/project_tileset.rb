module Drogmo
    class ProjectTileset
        attr_reader :label, :tiles, :tile_separation, :tile_margin, :tile_size, :path, :image_size
        def initialize(data_raw, path_relative)
            @label = data_raw["label"]
            @path = "#{path_relative}#{data_raw["path"]}"
            @tile_size = [data_raw["tileWidth"], data_raw["tileHeight"]]
            @tile_separation = [data_raw["tileSeparationX"], data_raw["tileSeparationY"]]
            @tile_margin = [data_raw["tileMarginX"],data_raw["tileMarginY"]]
            @image_size = $gtk.calcspritebox @path
            @tiles = []
            
            offset_x = @tile_margin.x
            offset_y = @tile_margin.y
            big_square_w = @tile_size.x + @tile_separation.x
            big_square_h = @tile_size.y + @tile_separation.y

            square = [(@image_size.x / big_square_w).to_i, (@image_size.y / big_square_h).to_i]
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
                if cellX >= square.x
                    cellX -= square.x
                    cellY += 1
                end
            end
        end
    end
end