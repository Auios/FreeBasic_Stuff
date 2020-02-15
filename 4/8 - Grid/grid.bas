'#include "scrn.bas"
#include "fbgfx.bi"
using fb

randomize timer

screenRes(800, 600, 32, 1, 0)

dim shared as ubyte tile(1 to 10, 1 to 10)

sub init()
    for ix as integer = 1 to 10
        for iy as integer = 1 to 10
            tile(ix,iy) = 5*rnd
        next iy
    next ix
end sub

sub RenderGrid(px as integer,py as integer,xc as integer,yc as integer,sz as integer)
    var div = 2.2
    
    line(px,py)-(px+((xc-1)*sz+sz*2),py+((yc-1)*sz+sz*2)),rgb(255,255,255),b
    
    for xx as integer = 0 to xc-1 step 1
        for yy as integer = 0 to yc-1 step 1
            
            select case tile(xx+1,yy+1)
            case 0
                circle(px+(xx*sz)+sz,py+(yy*sz)+sz),sz/div,rgb(0,0,255),,,,f
            case 1
                circle(px+(xx*sz)+sz,py+(yy*sz)+sz),sz/div,rgb(0,255,0),,,,f
            case 2
                circle(px+(xx*sz)+sz,py+(yy*sz)+sz),sz/div,rgb(0,255,255),,,,f
            case 3
                circle(px+(xx*sz)+sz,py+(yy*sz)+sz),sz/div,rgb(255,0,0),,,,f
            case 4
                circle(px+(xx*sz)+sz,py+(yy*sz)+sz),sz/div,rgb(255,0,255),,,,f
            case 5
                circle(px+(xx*sz)+sz,py+(yy*sz)+sz),sz/div,rgb(255,255,0),,,,f
            case else
                circle(px+(xx*sz)+sz,py+(yy*sz)+sz),sz/div,rgb(255,255,255),,,,f
            end select
            
            circle(px+(xx*sz)+sz,py+(yy*sz)+sz),sz/div
            
            draw string(15,15),"" & tile(1,1)
        next yy
    next xx
end sub

init()

do
    screenlock
        cls
        renderGrid(50,25,10,10,50)
    screenunlock
    
    sleep 15,1
loop until multikey(sc_escape)