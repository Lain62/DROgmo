module Drogmo
  class Project
    attr_reader :name, :ogmo_version, :background_color, :grid_color, :angles_radians, :tilesets, :layers,
                :layer_grid_default_size, :level_default_size, :level_min_size, :level_max_size, :level_values, :entity_tags, :entities

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
end

