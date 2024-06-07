module Drogmo
    class ProjectLayer
        attr_reader :data_raw
        def initialize(raw_data)
            @data_raw = raw_data
        end
    end
end