require "lib/Drogmo/Drogmo.rb"

def tick args
  args.state.ogmo ||= Drogmo::Project.new("data/OgmoTestProject.ogmo")
  args.state.level ||= Drogmo::Level.new(args.state.ogmo, "data/Level_1.json")


  args.outputs.sprites << args.state.level.layers["Tile_Layer"].sprites
  # puts args.state.level.layers["Tile_Layer"].sprites
  # puts args.state.ogmo.data.name
end




