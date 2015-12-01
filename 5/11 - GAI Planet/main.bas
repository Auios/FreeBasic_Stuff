#include "crt.bi"
#include "fbgfx.bi"

randomize timer

type planetAdv
    'Planet
    as ubyte planetType
    as uinteger metal,water
    
    'Life
    as uinteger population
    as uinteger slaves
    as uinteger troops
    as uinteger animals
    
    'Man made
    as uinteger fuel,energy,materials
    as uinteger food
    as uinteger weapons
    
    'Buildings
    as uinteger houses,hospitals
    as uinteger offences,defences
    as uinteger mines,powerPlants,farms
end type

type planet
    as uinteger ownerID
    as uinteger population, troops
    
    as uinteger health,housing
    as uinteger military,defense
    as uinteger trade,temple
    
