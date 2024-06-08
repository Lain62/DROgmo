module Drogmo
    class LevelGridLayer
        attr_reader :name, :eid, :offset_x, :offset_y, :grid_cell_width, :grid_cell_height, :grid_cells_x, :grid_cells_y, :grid, :grid2D, :array_mode, :data, :sprites
        def initialize(project, data)
            @name = data["name"]
            @eid = data["_eid"]
            @offset_x = data["offsetX"]
            @offset_y = data["offsetY"]
            @grid_cell_width = data["gridCellWidth"]
            @grid_cell_height = data["gridCellHeight"]
            @grid_cells_x = data["gridCellsX"]
            @grid_cells_y = data["gridCellsY"]
            @grid = []
            @grid2D = []
            @sprites = []
            @array_mode = data["arrayMode"]
            gid = data["grid"]
            gid2D = data["grid2D"]
            
            if @array_mode == 0
                setup_grid(gid, project)
            elsif @array_mode == 1
                setup_grid_2d(gid2D, project)
            end
        end

        def setup_grid(gid, project)
            gridX = 0
            gridY = @grid_cells_y - 1
            gid.each do |attribute|
                legend = project.layers[@name].legend[attribute]
                legendRGBA = project.layers[@name].legendRGBA[attribute]
                
                @grid << {
                    x: gridX * @grid_cell_width,
                    y: gridY * @grid_cell_height,
                    w:@grid_cell_width,
                    h:@grid_cell_height,
                    data: attribute,
                    color: legend,
                    colorRGBA: legendRGBA
                }
                gridX += 1
                if gridX >= @grid_cells_x
                    gridY -= 1
                    gridX -= @grid_cells_x
                end
            end

            cellX = 0
            cellY = @grid_cells_y - 1
            gid.each do |attribute|
                legend = project.layers[@name].legend[attribute]
                legendRGBA = project.layers[@name].legendRGBA[attribute]
                
                @sprites << {
                    x: cellX * @grid_cell_width,
                    y: cellY * @grid_cell_height,
                    w:@grid_cell_width,
                    h:@grid_cell_height,
                    data: attribute,
                    r: legendRGBA[0][0],
                    g: legendRGBA[0][1],
                    b: legendRGBA[0][2],
                    a: legendRGBA[1],
                    primitive_marker: :solid
                }
                cellX += 1
                if cellX >= @grid_cells_x
                    cellY -= 1
                    cellX -= @grid_cells_x
                end
            end
        end

        def setup_grid_2d(gid2D, project)
            gid2D.each_with_index do |row, index_y|
                row.each_with_index do |data, index_x|
                    legend = project.layers[@name].legend[data]
                    legendRGBA = project.layers[@name].legendRGBA[data]
                    @grid2D << {
                        x: index_x * @grid_cell_width,
                        y: index_y * @grid_cell_height,
                        w: @grid_cell_width,
                        h: @grid_cell_height,
                        data: data,
                        color: legend,
                        colorRGBA: legendRGBA
                    }

                    @sprites << {
                        x: index_x * @grid_cell_width,
                        y: index_y * @grid_cell_height,
                        w: @grid_cell_width,
                        h: @grid_cell_height,
                        data: data,
                        r: legendRGBA[0][0],
                        g: legendRGBA[0][1],
                        b: legendRGBA[0][2],
                        a: legendRGBA[1],
                        primitive_marker: :solid
                    }
                end
            end
        end
    end
end