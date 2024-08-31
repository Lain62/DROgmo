# DROgmo
`Version 0.2`  
A simple lib implementation of Ogmo Editor for DragonRuby.  
Made for Ogmo Editor version 3.4.0  

## TODO
- add support for level decal layer
- put samples on main.rb
- add more comments on properties

## Installation
1. Download the zip
2. Extract the lib folder into your mygame directory
3. add `require "lib/drogmo/drogmo.rb"` at the top of your main.rb

## Using download_stb_rb()
```ruby
# put this outside of the tick function
$gtk.download_stb_rb "https://github.com/Lain62/DROgmo/blob/main/lib/drogmo/drogmo.rb"

# then run dragonruby once and delete the line after
# and then change the require to be like this
require 'Lain62/DROgmo/drogmo.rb'
```

## Usage
A quick way to use this lib
```ruby
require "lib/drogmo/drogmo.rb" # loads the DROgmo library, put this on top of your main.rb file
# unless youre using download stb 

args.state.ogmo ||= Drogmo::Project.new("data/OgmoTestProject.ogmo") # loads the main ogmo project
args.state.level ||= Drogmo::Level.new(args.state.ogmo, "data/level_1.json") # loads the individual level from ogmo

args.outputs.primitives << args.state.level.layers["Tile_Layer"].sprites
```
> WARNING: Currently DROgmo only supports having the files be in the same directory, or sub-folders of the main Ogmo Project Directory.  
> This includes tilesheets sprites, Entity images, and so on
> Make sure to put the main Ogmo Project file on the very top of the folder directory
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

### Project Entity properties
```ruby
{
    export_id:
    name:
    limit:
    size:
    origin:
    origin_anchored:
    shape:
    color:
    colorRGBA:
    tile_x:
    tile_y:
    tile_size:
    resizeable_x:
    resizeable_y:
    rotatable:
    rotation_degrees:
    can_flip_x:
    can_flip_y:
    can_set_color:
    node_limit:
    node_display:
    node_ghost:
    tags:
    values:
    texture:
    texture_path:
}
```

### Project Tileset properties
```ruby
{
    label:
    path:
    tile_size:
    tile_seperation:
    tile_margin:
    image_size:
    tiles:
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
    tileset:            # Referrs to the data from project tileset of the specific tileset
    tileset_name:       # For the name of the tileset itself
    sprites:            # Filled with sprite with properties { x, y, w, h, primitive_marker(:sprites), path, tile_x, tile_y, tile_w, tile_h }

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
    entities:           # Filled with entity with properties { name, id, eid, x, y, width, height, origin_x, origin_y, flipped_x, flipped_y, rotation, data } data here reffers to project entity properties of the specific entity
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
    grid:               # For 2D Array mode Filled with object with the properties { x, y, w, h, data, color, colorRGBA} data here referrs to the object id
    grid2D:             # For 2D Array mode Filled with object with the properties { x, y, w, h, data, color, colorRGBA} data here referrs to the object id
    sprites:            # Filled with object with the properties { x, y, w, h, primitive_marker(:solid), data, r, g, b, a }
    array_mode:
}
```

