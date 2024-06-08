# DROgmo
A simple wrapper implementation of Ogmo Editor for DragonRuby.  
Made for Ogmo Editor version 3.4.0  

## TODO
- add support for level decal layer

## Usage
A quick way to use this wrapper
```ruby
require "lib/drogmo/drogmo.rb" # loads the DROgmo library, put this on top of your main.rb file

args.state.ogmo ||= Drogmo::Project.new("data/OgmoTestProject.ogmo") # loads the main ogmo project
args.state.level ||= Drogmo::Level.new(args.state.ogmo, "data/level_1.json") # loads the individual level from ogmo

args.outputs.primitives << args.state.level.layers["Tile_Layer"].sprites
```
> WARNING: Currently DROgmo only supports having the files be in the same directory, or sub-folders of the main Ogmo Project Directory.  
> This includes tilesheets sprites, Entity images, and so on
## Project
You can acess Ogmo Projects using the `Drogmo::Project.new(path)`
```ruby
args.state.ogmo ||= Drogmo::Project.new("data/OgmoTestProject.ogmo")
```
### Project Properties
```ruby
{
    name:
    ogmo_version:
    background_color:
    grid_color:
    angles_radians:
    layer_grid_default_size:
    level_default_size:
    level_min_size:
    level_max_size:
    level_values:
    entity_tags:
    layers:
    tilesets:
    entities:
}
```

### Project Layer
Each layer from project has its own properties 
DROgmo supports all project layer type 

#### Project Tile Layer Properties
```ruby
{
    definition:
    name:
    grid_size:
    export_id:
    export_mode:
    array_mode:
    default_tileset
}
```

#### Project Entity Layer Properties
```ruby
{
    definition:
    name:
    grid_size:
    export_id:
    required_tags:
    excluded_tags
}
```

#### Project Grid Layer Properties
```ruby
{
    definition:
    name:
    grid_size:
    export_id:
    array_mode:
    legend:
    legendRGBA:         # Like legends but outputs an RGBA array instead
}
```

## Levels
You can acess levels using the `Drogmo::Level.new(ogmo_project, Level_path)`
```ruby
args.state.level ||= Drogmo::Level.new(args.state.ogmo, "data/level_1.json")
```

### Level Layers
To access a layer of a level simply do 
```ruby
args.state.level.layers["Tile Layer"] # Get layer by name
```
DROgmo doesnt support decal level layer currently
#### Level Tile Layer Properties
```ruby
{
    name:
    eid:
    offset_x:           
    offset_y:           
    grid_cell_width:    
    grid_cell_height:   
    grid_cells_x:       
    grid_cells_y:       
    data:               # For ID's Export mode and 1D Array mode
    data_coords:        # For Coords Export mode and 1D Array mode
    data2D:             # For ID's Export mode and 2D Array mode
    data_coords2D:      # For Coords Export mode and 2D Array mode
    tileset:            # For raw data from the main ogmo project of the specific tileset used
    tileset_name:       # For the name of the tileset itself
    sprites:            # Filled with sprite that responds to { x, y, w, h, primitive_marker(sprites), path, tile_x, tile_y, tile_w, tile_h }

}
```

#### Level Entity Layer Properties
```ruby
{
    name:
    eid:
    offset_x:
    offset_y:
    grid_cell_width:
    grid_cell_height:
    grid_cells_x:
    grid_cells_y:
    entities:           # Filled with entity that responds to { name, id, eid, x, y, width, height, origin_x, origin_y, flipped_x, flipped_y, rotation, data } data here reffers to the raw data from the main ogmo project of the specific entity used
}
```

#### Level Grid Layer Properties
```ruby
{
    name:
    eid:
    offset_x:
    offset_y:
    grid_cell_width:
    grid_cell_height:
    grid_cells_x:
    grid_cells_y:
    grid:               # For 1D Array mode
    grid2D:             # For 2D Array mode
    sprites:
    array_mode:
}
```

