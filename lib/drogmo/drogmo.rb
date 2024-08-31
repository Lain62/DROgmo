# frozen_string_literal: true

# A library that parses files from OGMO EDITOR 3
module Drogmo
  VERSION = '0.2'

  # This is a handy code to convert from hex color into rgba colors
  # code from https://gist.github.com/amirrajan/46cafad5f024916264f1c8c0c16de390
  # @param data [String] hexcode in the format of rrggbb or rrggbbaa
  # @return [Array]
  def self.color(data)
    if data.length != 6 && data.length != 8
      raise "Color must be in the format rrggbb or rrggbbaa. This is what you provided #{data}."
    end

    working_number = if data.length == 6
                       0xff000000 + data.to_i(16)
                     else
                       [*data[-2..-1], *data[0..5]].join.to_i(16)
                     end

    components = working_number.to_s(16).each_char.each_slice(2).map do |parts|
      parts.join.to_i(16)
    end

    [components[1..-1], components[0]]
  end

  # Main class for parsing the project file (ex: project.ogmo)
  # Class must be created before creating the level class
  class Project
    attr_reader :name, :ogmo_version, :background_color, :grid_color, :angles_radians, :tilesets, :layers,
                :layer_grid_default_size, :level_default_size, :level_min_size, :level_max_size, :level_values, :entity_tags, :entities

    # @param path [String] Path to an ogmo file
    def initialize(path)
      data = $gtk.parse_json_file(path)
      @tilesets = {}
      @layers = {}
      @entities = {}
      path_divided = path.split('/')
      file_name = path_divided[-1]
      path_relative = path.gsub("#{file_name}", '')

      @name = data['name']
      @ogmo_version = data['ogmoVersion']
      @background_color = data['backgroundColor']
      @grid_color = data['gridColor']
      @angles_radians = data['anglesRadians']
      @layer_grid_default_size = [data['layerGridDefaultSize']['x'], data['layerGridDefaultSize']['y']]
      @level_default_size = [data['levelDefaultSize']['x'], data['levelDefaultSize']['y']]
      @level_min_size = [data['levelMinSize']['x'], data['levelMinSize']['y']]
      @level_max_size = [data['levelMaxSize']['x'], data['levelMaxSize']['y']]
      @level_values = data['levelValues']
      @entity_tags = data['entityTags']

      data['layers'].each do |layer|
        case layer['definition']
        when 'tile'
          @layers["#{layer['name']}"] = ProjectLayerTile.new(layer)
        when 'entity'
          @layers["#{layer['name']}"] = ProjectLayerEntity.new(layer)
        when 'grid'
          @layers["#{layer['name']}"] = ProjectLayerGrid.new(layer)
        when 'decal'
          @layers["#{layer['name']}"] = ProjectLayerDecal.new(layer)
        end
      end

      data['tilesets'].each do |tileset|
        @tilesets["#{tileset['label']}"] = ProjectTileset.new(tileset, path_relative)
      end

      data['entities'].each do |entity|
        @entities["#{entity['name']}"] = ProjectEntity.new(entity, path_relative)
      end
    end
  end

  # Class for a layer tile in a project file
  class ProjectLayerTile
    attr_reader :definition, :name, :grid_size, :export_id, :export_mode, :array_mode, :default_tileset

    # @param data_raw [Hash] raw data of layer
    def initialize(data_raw)
      @definition = data_raw['definition']
      @name = data_raw['name']
      @grid_size = [data_raw['gridSize']['x'], data_raw['gridSize']['y']]
      @export_id = data_raw['exportID']
      @export_mode = data_raw['exportMode']
      @array_mode = data_raw['arrayMode']
      @default_tileset = data_raw['defaultTileset']
    end
  end

  # Class for entity layer in a project file
  class ProjectLayerEntity
    attr_reader :definition, :name, :grid_size, :export_id, :required_tags, :excluded_tags

    # @param data_raw [Hash] raw data of layer
    def initialize(data_raw)
      @definition = data_raw['definition']
      @name = data_raw['name']
      @grid_size = [data_raw['gridSize']['x'], data_raw['gridSize']['y']]
      @export_id = data_raw['exportID']
      @required_tags = data_raw['requiredTags']
      @excluded_tags = data_raw['excludedTags']
    end
  end

  # Class for grid layer in a project file
  class ProjectLayerGrid
    attr_reader :definition, :name, :grid_size, :export_id, :array_mode, :legend, :legendRGBA

    # @param data_raw [Hash] raw data of layer
    def initialize(data_raw)
      @definition = data_raw['definition']
      @name = data_raw['name']
      @grid_size = [data_raw['gridSize']['x'], data_raw['gridSize']['y']]
      @export_id = data_raw['exportID']
      @array_mode = data_raw['arrayMode']
      @legend = data_raw['legend']
      @legendRGBA = {}
      @legend.each do |attribute|
        color_convert = attribute[1].gsub('#', '')
        @legendRGBA[attribute[0]] = Drogmo.color(color_convert)
      end
    end
  end

  # Class for decal layer in a project file
  class ProjectLayerDecal
    attr_reader :definition, :name, :grid_size, :export_id, :folder, :include_image_sequence, :scaleable, :rotatable,
                :values

    # @param data_raw [Hash] raw data of layer
    def initialize(data_raw)
      @definition = data_raw['definition']
      @name = data_raw['name']
      @grid_size = [data_raw['gridSize']['x'], data_raw['gridSize']['y']]
      @export_id = data_raw['exportID']
      @folder = data_raw['folder']
      @include_image_sequence = data_raw['includeImageSequence']
      @scaleable = data_raw['scaleable']
      @rotatable = data_raw['rotatable']
      @values = data_raw['values']
    end
  end

  # Class for all entities in a project file
  class ProjectEntity
    attr_reader :export_id, :name, :limit, :size, :origin, :origin_anchored, :shape, :color, :colorRGBA, :tile_x,
                :tile_y, :tile_size, :resizeable_x, :resizeable_y, :rotatable, :rotation_degrees, :can_flip_x, :can_flip_y, :can_set_color, :has_nodes, :node_limit, :node_display, :node_ghost, :tags, :values, :texture, :texture_path

    # @param data [Hash] raw data of layer
    # @param relative_path [String] the relative path of the entity image
    def initialize(data, relative_path)
      @export_id = data['exportID']
      @name = data['name']
      @limit = data['limit']
      @size = [data['size']['x'], data['size']['y']]
      @origin = [data['origin']['x'], data['origin']['y']]
      @origin_anchored = data['originAnchored']
      @shape = data['shape']
      @color = data['color']
      color_convert = @color.gsub('#', '')
      @colorRGBA = Drogmo.color(color_convert)
      @tile_x = data['tileX']
      @tile_y = data['tileY']
      @tile_size = [data['tileSize']['x'], data['tileSize']['y']]
      @resizeable_x = data['resizeableX']
      @resizeable_y = data['resizeableY']
      @rotatable = data['rotatable']
      @rotation_degrees = data['rotationDegrees']
      @can_flip_x = data['canFlipX']
      @can_flip_y = data['canFlipY']
      @can_set_color = data['canSetColor']
      @has_nodes = data['hasNodes']
      @node_limit = data['nodeLimit']
      @node_display = data['nodeDisplay']
      @node_ghost = data['nodeGhost']
      @tags = data['tags']
      @values = data['values']
      @texture = data['texture']
      @texture_path = "#{relative_path}#{data['texture']}"
    end
  end

  # Class for all tilesets in a project
  class ProjectTileset
    attr_reader :label, :tiles, :tile_separation, :tile_margin, :tile_size, :path, :image_size

    # @param data_raw [Hash] raw data of layer
    # @param path_relative [String] relative path of the tileset
    def initialize(data_raw, path_relative)
      @label = data_raw['label']
      @path = "#{path_relative}#{data_raw['path']}"
      @tile_size = [data_raw['tileWidth'], data_raw['tileHeight']]
      @tile_separation = [data_raw['tileSeparationX'], data_raw['tileSeparationY']]
      @tile_margin = [data_raw['tileMarginX'], data_raw['tileMarginY']]
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

  # Class for parsing level files
  class Level
    attr_reader :ogmo_version, :width, :height, :offset_x, :offset_y, :values, :layers

    # @param project_data [Project] data for the ogmo project file
    # @param path [String] path to the level file
    def initialize(project_data, path)
      data = $gtk.parse_json_file(path)
      @ogmo_version = data['ogmoVersion']
      @width = data['width']
      @height = data['height']
      @offset_x = data['offsetX']
      @offset_y = data['offsetY']
      @values = data['values']
      @layers = {}

      data['layers'].each do |layer|
        case project_data.layers["#{layer['name']}"].definition
        when 'tile'
          @layers["#{layer['name']}"] = LevelTileLayer.new(project_data, layer)
        when 'entity'
          @layers["#{layer['name']}"] = LevelEntityLayer.new(project_data, layer, self)
        when 'grid'
          @layers["#{layer['name']}"] = LevelGridLayer.new(project_data, layer)
        end
      end
    end
  end

  # Class for parsing a tile layer in a level
  class LevelTileLayer
    attr_reader :sprites, :name, :eid, :offset_x, :offset_y, :grid_cell_width, :grid_cell_height, :grid_cells_x,
                :grid_cells_y, :tileset, :data, :data_coords, :data2D, :data_coords2D, :export_mode, :array_mode, :tileset_name

    # @param project [Project] ogmo file project data
    # @param raw_data [Hash] data of the layer
    def initialize(project, raw_data)
      @tileset = nil
      @project_data = nil
      @sprites = []

      @name = raw_data['name']
      @eid = raw_data['_eid']
      @offset_x = raw_data['offsetX']
      @offset_y = raw_data['offsetY']
      @grid_cell_width = raw_data['gridCellWidth']
      @grid_cell_height = raw_data['gridCellHeight']
      @grid_cells_x = raw_data['gridCellsX']
      @grid_cells_y = raw_data['gridCellsY']
      @data = raw_data['data']
      @data_coords = raw_data['dataCoords']
      @data2D = raw_data['data2D']
      @data_coords2D = raw_data['dataCoords2D']
      @export_mode = raw_data['exportMode']
      @array_mode = raw_data['arrayMode']

      @tileset = project.tilesets["#{raw_data['tileset']}"]
      @tileset_name = raw_data['tileset']

      project.layers.each do |layer|
        @project_data = layer[1] if layer[1].export_id == @eid
      end

      if @export_mode == 0 && @array_mode == 0
        cellY = @grid_cells_y - 1
        cellX = 0
        @data.each do |tile|
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
          cellX += 1
          if cellX >= @grid_cells_x
            cellY -= 1
            cellX -= @grid_cells_x
          end
        end
      end

      if @export_mode == 1 && @array_mode == 0
        cellY = @grid_cells_y - 1
        cellX = 0
        @data_coords.each do |tile|
          @sprites << {
            x: cellX * @grid_cell_width,
            y: cellY * @grid_cell_height,
            w: @grid_cell_width,
            h: @grid_cell_height,
            primitive_marker: :sprite,
            path: @tileset.path,
            tile_x: tile.x * @grid_cell_width,
            tile_y: tile.y * @grid_cell_height,
            tile_w: @grid_cell_width,
            tile_h: @grid_cell_height
          }
          cellX += 1
          if cellX >= @grid_cells_x
            cellY -= 1
            cellX -= @grid_cells_x
          end
        end
      end

      if @export_mode == 0 && @array_mode == 1
        @data2D.reverse.each_with_index do |row, index_y|
          row.each_with_index do |tile, index_x|
            if tile == -1
            else
              tiles = @tileset.tiles[tile]
              @sprites << {
                x: index_x * @grid_cell_width,
                y: index_y * @grid_cell_height,
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

      return unless @export_mode == 1 && @array_mode == 1

      @data_coords2D.each_with_index do |row, index_y|
        row.each_with_index do |tile, index_x|
          @sprites << {
            x: index_x * @grid_cell_width,
            y: index_y * @grid_cell_height,
            w: @grid_cell_width,
            h: @grid_cell_height,
            primitive_marker: :sprite,
            path: @tileset.path,
            tile_x: tile.x * @grid_cell_width,
            tile_y: tile.y * @grid_cell_height,
            tile_w: @grid_cell_width,
            tile_h: @grid_cell_height
          }
        end
      end
    end
  end

  # Class for parsing an entity layer for a level
  class LevelEntityLayer
    attr_reader :name, :eid, :offset_x, :offset_y, :grid_cell_width, :grid_cell_height, :grid_cells_x, :grid_cells_y,
                :entities

    # @param project [Project] ogmo project data
    # @param data [Hash] layer data
    # @param level_data [Level] level data
    def initialize(project, data, level_data)
      @name = data['name']
      @eid = data['_eid']
      @offset_x = data['offsetX']
      @offset_y = data['offsetY']
      @grid_cell_width = data['gridCellWidth']
      @grid_cell_height = data['gridCellHeight']
      @grid_cells_x = data['gridCellsX']
      @grid_cells_y = data['gridCellsY']
      @entities = []

      data['entities'].each do |entity|
        width = @grid_cell_width
        height = @grid_cell_height
        flipped_x = nil
        flipped_y = nil
        rotation = 0

        rotation = entity['rotation'] unless entity['rotation'].nil?

        width = entity['width'] unless entity['width'].nil?
        height = entity['height'] unless entity['height'].nil?

        flipped_x = entity['flippedX'] unless entity['flippedX'].nil?
        flipped_y = entity['flippedY'] unless entity['flippedY'].nil?

        import_data = project.entities[entity['name']]
        @entities << {
          name: entity['name'],
          id: entity['id'],
          eid: entity['_eid'],
          x: entity['x'],
          y: level_data.height - entity['y'] - height, # Weird formula to compensate for the origin point being in the top left
          origin_x: entity['originX'],
          origin_y: entity['originY'],
          values: entity['values'],
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

  # Class for parsing a grid layer in a level
  class LevelGridLayer
    attr_reader :name, :eid, :offset_x, :offset_y, :grid_cell_width, :grid_cell_height, :grid_cells_x,
                :grid_cells_y, :grid, :grid2D, :array_mode, :data, :sprites

    # @param project [Project] ogmo project data
    # @param data [Hash] grid layer data
    def initialize(project, data)
      @name = data['name']
      @eid = data['_eid']
      @offset_x = data['offsetX']
      @offset_y = data['offsetY']
      @grid_cell_width = data['gridCellWidth']
      @grid_cell_height = data['gridCellHeight']
      @grid_cells_x = data['gridCellsX']
      @grid_cells_y = data['gridCellsY']
      @grid = []
      @grid2D = []
      @sprites = []
      @array_mode = data['arrayMode']
      gid = data['grid']
      gid2D = data['grid2D']

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
          w: @grid_cell_width,
          h: @grid_cell_height,
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
          w: @grid_cell_width,
          h: @grid_cell_height,
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
