#include "scrn.bas"
#include "fbgfx.bi"
using fb

randomize timer

scrn(800,600,32,0)

dim as any ptr img

Paint (0, 0), RGB(64, 128, 255)

img = imagecreate(sc.x,sc.y,rgba(0,0,0,0))

dim as uinteger r = 5

do
    r+=1
    circle img,(sc.x/2,sc.y/2),r,rgba(128,0,164,5),,,,f
    Put(0,0), img, Alpha
    
    dim as string dis = "" & r
    line(0,0) - (len(dis)*8,8),,"bf"
    draw string(1,1),"" & r,rgb(0,0,0)
    sleep 10
loop until multikey(sc_escape)

imageDestroy img
end
