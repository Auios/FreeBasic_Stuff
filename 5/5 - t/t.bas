#include "fbgfx.bi"
#include "scrn.bas"
#include "crt.bi"

using fb

randomize timer

printf(!"Init screen\n")
scrn()

enum state
    ground
    break
    top
end enum

type treeProp
    as state ID(1)
    as integer x(1),y(1)
    as single growth(1)
end type

dim as treeProp tr(0)

'Subs/Funcs
sub drawFrame()
    line(0,0)-(sc.x,sc.y),rgb(100,100,100),"bf"
    line(sc.x/4,sc.y/4)-(sc.x/4*3,sc.y/4*3),rgb(200,200,200),"bf"
end sub

'Init
for i as integer = lbound(tr) to ubound(tr)
    with tr(i)
        .x(0) = (sc.x/2*rnd)+(sc.x/4)
        .y(0) = (sc.y/2*rnd)+(sc.y/4)
    end with
next i

'Main loop
do
    for i as integer = lbound(tr) to ubound(tr)
        with tr(i)
            for j as integer = lbound(.ID) to ubound(.ID)
                
            next j
        end with
    next i
    
    var k = inkey()
    select case ucase(k)
    case "T"
        
    end select
    
    screenlock
    cls
    drawFrame()
    screenunlock
    
    sleep 1,1
loop until multikey(sc_escape)
