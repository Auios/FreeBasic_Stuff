#include "fbgfx.bi"
#include "scrn.bas"
using fb

scrn(576,432)
'64x48

dim shared as ubyte sx,sy
dim as ubyte swi = 1
dim as uinteger clr

sx = sc.x/9
sy = sc.y/9

sub drawPlayer(x as uinteger,y as uinteger)
    circle(x*sx+sx/2,y*sy+sy/2),sy/2,rgb(100,100,200),,,,f
end sub

sub renderBack(swi as ubyte,clr as uinteger)
    for x as integer = 0 to 8
        for y as integer = 0 to 8
            swi = swi xor 1
            if swi = 1 then
                clr = rgb(175,175,175)
            else
                clr = rgb(125,125,125)
            end if
            
            line(x*sx,y*sy)-(x*sx+sx,y*sy+sy),clr,"bf"
            
        next y
    next x
end sub

renderBack(swi,clr)
drawPlayer(4,4)

sleep