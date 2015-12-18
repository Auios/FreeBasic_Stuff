#include "fbgfx.bi"
#include "scrn.bas"

dim as uinteger clr

scrn()

for y as ubyte = 0 to 254
    for x as ubyte = 0 to 254
        dim as ubyte gr = 1*rnd+1
        
        if gr = 2 then gr = 1*rnd+1
        if gr = 2 then gr = 1*rnd+1
        
        select case gr
        case 1
            clr = rgb(255,255,255)
        case 2
            clr = rgb(255,0,0)
        end select
        
        pset(x,y),clr
    next x
next y

sleep