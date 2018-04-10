#include "GL2D.bi"

#include once "empire.bas"

enum Terrain
    void
    water
    sand
    dune
    plain
    hill
    mountain
end enum

type Tile
    as integer x,y
    as Terrain terrain
    as Empire owner
    
    declare sub render()
end type

sub Tile.render()
    
end sub