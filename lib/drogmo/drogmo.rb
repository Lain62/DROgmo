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

  require_relative 'project_entity'
  require_relative 'project_tileset'
  require_relative 'level'
  require_relative 'level_tile_layer'
  require_relative 'level_entity_layer'
  require_relative 'level_grid_layer'
end
