#include once "Tile.bas"

type World
    as uinteger size
    as WorldTile ptr tile
    
    declare sub generate(size as uinteger)
    declare sub save(fileName as string)
    declare sub load(fileName as string)
end type

sub World.generate(size as uinteger)
    this.size = size
    this.tile = new WorldTile[this.size^2]
    for i as integer = 0 to this.size^2-1
        dim as single chance = rnd()
        if(chance >= 0.25) then
            this.tile[i].terrain = Terrain.grass
        else
            this.tile[i].terrain = Terrain.water
        end if
    next i
end sub

sub World.save(fileName as string)
    dim as integer ff = freeFile()
    open fileName for binary as #ff
    put #ff,, this.size
    for i as uinteger = 0 to this.size^2-1
        put #ff,, this.tile[i]
    next i
    close #ff
end sub

sub World.load(fileName as string)
    dim as integer ff = freeFile()
    open fileName for binary as #ff
    get #ff,, this.size
    this.tile = new WorldTile[this.size^2]
    for i as uinteger = 0 to this.size^2-1
        get #ff,, this.tile[i]
    next i
    close #ff
end sub
