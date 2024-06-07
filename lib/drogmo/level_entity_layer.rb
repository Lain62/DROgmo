module Drogmo
    class LevelEntityLayer
        attr_reader :data
        def initialize(project_data, data)
            @project_data = project_data
            @entities_data = nil
            @data = data
            setup
        end

        def setup
            @project_data
        end
    end
end