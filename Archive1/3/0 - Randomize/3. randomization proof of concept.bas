#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
scrnx = 800
scrny = 600
screenres scrnx,scrny,8,2,0

dim shared as integer num = 10

type entprop
    as integer x,y
    as uinteger clr
end type
dim shared as entprop ent(num)

for i as integer = 0 to num
    with ent(i)
        .x = scrnx*rnd
        .y = scrny*rnd
        .clr = rgb(255*rnd,255*rnd,255*rnd)
    end with
next i

do
    screenlock
    for i as integer = 0 to num
        with ent(i)
            dim as integer sldir = 5*rnd                                        'Using 5 instead of 3
            select case sldir
            case 1
                .x+=1
            case 2
                .x-=1
            case 3
                .y+=1
            case 4
                .y-=1
            end select
            
            pset(.x,.y),.clr
        end with
    next i
    screenunlock
    
    sleep 1
loop until multikey(sc_escape)