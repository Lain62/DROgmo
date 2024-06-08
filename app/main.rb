require "lib/drogmo/drogmo.rb"

def tick args
  args.state.ogmo ||= Drogmo::Project.new("data/OgmoTestProject.ogmo")
  args.state.level ||= Drogmo::Level.new(args.state.ogmo, "data/level_1.json")

  args.outputs.primitives << args.state.level.layers["Grid_Layer"].sprites
  # args.outputs.sprites << args.state.level.layers["Tile_Layer"].sprites
  # puts args.state.level.layers["Grid_Layer"].sprites
end




