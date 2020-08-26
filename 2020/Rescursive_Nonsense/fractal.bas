#include "fbgfx.bi"

using fb

screenres(1000, 1000, 32, 1, 0)

const zoom_speed = 0.05
const move_speed = 5
dim shared as single zoom = 2
dim shared as single offx = 500
dim shared as single offy = 500

enum direction
    none
    north
    east
    south
    west
end enum

sub thing(x as single, y as single, level as integer, size as single, d as direction = direction.none)
    if(level > 0) then
        dim as single xx = x * zoom + offx
        dim as single yy = y * zoom + offy
        circle(xx, yy), size*zoom, rgb(level/2*255, 100, 100)
        if(d <> direction.south) then thing(x, y-size*2, level-1, size/2, direction.north)
        if(d <> direction.west) then thing(x+size*2, y, level-1, size/2, direction.east)
        if(d <> direction.north) then thing(x, y+size*2, level-1, size/2, direction.south)
        if(d <> direction.east) then thing(x-size*2, y, level-1, size/2, direction.west)
    end if
end sub

dim as boolean run_app = true

while(run_app)
    screenLock()
    cls()
    thing(0, 0, 10, 100)
    'thing(0, 0, 5, 25)
    screenUnlock()
    sleep(1, 1)
    if(multikey(sc_escape)) then run_app = false
    if(multikey(sc_f)) then zoom*=1 + zoom_speed
    if(multikey(sc_c)) then zoom*=1 - zoom_speed
    if(multikey(sc_w)) then offy+=move_speed
    if(multikey(sc_s)) then offy-=move_speed
    if(multikey(sc_a)) then offx+=move_speed
    if(multikey(sc_d)) then offx-=move_speed
wend
