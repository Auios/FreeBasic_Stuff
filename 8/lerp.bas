#include "crt/math.bi"


function lerp(curr as single, dest as single, chng as single) as single
    return curr + chng * (dest - curr)
end function


#include "fbgfx.bi"

using fb

randomize(timer())

screenRes(800, 600, 32, 1, 0)

dim as integer mx, my
dim as boolean runApp = true
dim as single x,y
dim as single tx, ty
dim as integer radius = 3

while(runApp)
    getMouse(mx, my)
    
    if(multikey(sc_escape)) then runApp = false
    if(multikey(sc_a)) then
        tx = mx
        ty = my
    end if
    'if(multikey(sc_s)) then
        x = lerp(x, mx, 0.005)
        y = lerp(y, my, 0.005)
    'end if
    
    screenLock()
    cls()
    circle(tx, ty), radius, rgb(200, 100, 100),,,,f
    circle(x, y), radius, rgb(100, 200, 100),,,,f
    circle(mx, my), radius, rgb(100, 200, 200),,,,f
    screenUnlock()
    
    sleep(1, 1)
wend
