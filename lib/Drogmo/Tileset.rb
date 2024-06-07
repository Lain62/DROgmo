module Drogmo
    class Tileset
        attr_reader :data_raw
        def initialize(tileset_data, path_relative)
            @data_raw = tileset_data
            @path_relative = path_relative
            @path = nil
            setup
        end

        def setup
            @path = "#{@path_relative}#{@data_raw["path"]}"
        end

        def update
            if @data_raw["label"] == "Tileset_1"
                $args.outputs.sprites << {
                    x: 0,
                    y: 0,
                    w: 255,
                    h: 255,
                    path: @path
                }
            end
        end
    end
end