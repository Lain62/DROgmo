module Drogmo
    class Project
        attr_reader :data_raw
        def initialize(path)
            @file_name_raw = nil
            @path_raw = path
            @data_raw = $gtk.parse_json_file(@path_raw)
            @tilesets = []
            @path_relative = nil
            parse_path
            setup
        end

        def setup
            @data_raw.each_pair do |attribute|
                case attribute[0]
                when "tilesets"
                    attribute[1].each do |tileset|
                        @tilesets << Tileset.new(tileset, @path_relative)
                    end
                end
            end
            
            
        end

        def parse_path
            path_divided = @path_raw.split("/")
            @file_name_raw = path_divided[-1]
            @path_relative = @path_raw.gsub("#{@file_name_raw}", "")
        end
    
        def data
            {
                name: @data_raw["name"],
            }
        end      

        def update
            @tilesets.each do |tileset|
                tileset.update
            end
        end
    end
end