module Drogmo
    # code from https://gist.github.com/amirrajan/46cafad5f024916264f1c8c0c16de390
    def self.color(data)
        if data.length != 6 && data.length != 8
          raise "Color must be in the format rrggbb or rrggbbaa. This is what you provided #{self}."
        end
        if data.length == 6
          working_number = 0xff000000 + data.to_i(16)
        else
          working_number = [*data[-2..-1], *data[0..5]].join.to_i(16)
        end
    
        components = working_number.to_s(16).each_char.each_slice(2).map do |parts|
          parts.join.to_i(16)
        end
    
        [components[1..-1], components[0]]
      end
end