enum Terrain
    void
    water
    sand
    grass
    rock
    snow
end enum

type WorldTile
    as Terrain terrain = Terrain.void
    as ubyte level = 0
    as uinteger ownerID = 0
end type
