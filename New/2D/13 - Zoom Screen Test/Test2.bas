#include "fbgfx.bi"
'include "auios/auios.bi"

'using auios

'dim as AuWindow wnd = AuWindowInit(800,600,"Application",32,1,0)

screenres(800,600,32,1,0)

dim as uinteger clr
dim as single x,y,clrset = 1
x = 640
y = 480

'AuWindowCreate(wnd)
window screen (0,0)-(x,y)

do
    clrset = 1
    if multikey(fb.sc_up) then
        x+=1
        y+=1
        window(0,0)-(x,y)
    end if
    if multikey(fb.sc_down) then
        x-=1
        y-=1
        window(0,0)-(x,y)
    end if
    
    screenlock
    cls
    pset(5,2)
'    for yy as integer = 1 to y
'        for xx as integer = 1 to x
'            if clrset then
'                clr = rgb(200,200,200)
'            else
'                clr = rgb(100,100,100)
'            end if
'            
'            pset(xx,yy),clr
'            clrset = clrset xor 1
'        next xx
'    next yy
    screenunlock
    
    sleep 1,1
loop until inkey = chr(27)

'end AuWindowDestroy(wnd)
end 0
