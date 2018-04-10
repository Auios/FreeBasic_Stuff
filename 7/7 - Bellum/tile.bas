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
    as Terrain trn
    as Empire owner
    
    declare sub render()
end type

sub Tile.render()
    select case this.trn
    case Terrain.void
    case Terrain.water
    case Terrain.sand
    case Terrain.dune
    case Terrain.plain
    case Terrain.hill
    case Terrain.mountain
    end select
end sub