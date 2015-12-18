#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,1

dim shared as integer sx,sy,max,tiles = 16
sx = scrnx/tiles
sy = scrny/tiles

type entprop
    as integer x,y
end type
dim shared as entprop ent(max)

sub controller(i as integer)
    with ent(i)
        if multikey(sc_w) then .y-=sy
        if multikey(sc_s) then .y+=sy
        if multikey(sc_a) then .x-=sx
        if multikey(sc_d) then .x+=sx
    end with
end sub

sub render(i as integer)
    with ent(i)
        line(.x,.y)-(.x+sx,.y+sy),,"bf"
    end with
end sub

do
    screenlock
        cls
        for i as integer = 0 to max
            controller(i)
            render(i)
        next i
    screenunlock
    sleep 10
loop until multikey(sc_escape)