module Drogmo
    class ProjectEntity
        attr_reader :export_id, :name, :limit, :size, :origin, :origin_anchored, :shape, :color, :colorRGBA
        attr_reader :tile_x, :tile_y, :tile_size, :resizeable_x, :resizeable_y, :rotatable, :rotation_degrees
        attr_reader :can_flip_x, :can_flip_y, :can_set_color, :has_nodes, :node_limit, :node_display
        attr_reader :node_ghost, :tags, :values, :texture, :texture_path
        def initialize(data, relative_path)
            @export_id = data["exportID"]
            @name = data["name"]
            @limit = data["limit"]
            @size = [data["size"]["x"], data["size"]["y"]]
            @origin = [data["origin"]["x"], data["origin"]["y"]]
            @origin_anchored = data["originAnchored"]
            @shape = data["shape"]
            @color = data["color"]
            color_convert = @color.gsub("#", "")
            @colorRGBA = Drogmo.color(color_convert)
            @tile_x = data["tileX"]
            @tile_y = data["tileY"]
            @tile_size = [data["tileSize"]["x"], data["tileSize"]["y"]]
            @resizeable_x = data["resizeableX"]
            @resizeable_y = data["resizeableY"]
            @rotatable = data["rotatable"]
            @rotation_degrees = data["rotationDegrees"]
            @can_flip_x = data["canFlipX"]
            @can_flip_y = data["canFlipY"]
            @can_set_color = data["canSetColor"]
            @has_nodes = data["hasNodes"]
            @node_limit = data["nodeLimit"]
            @node_display = data["nodeDisplay"]
            @node_ghost = data["nodeGhost"]
            @tags = data["tags"]
            @values = data["values"]
            @texture = data["texture"]
            @texture_path = "#{relative_path}#{data["texture"]}"
        end
    end
end