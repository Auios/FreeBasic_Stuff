#include "scrn.bas"
#include "fbgfx.bi"
using fb
randomize timer

scrn(640,480,32,1)

dim as ushort sw,st
st = 16

for yy as integer = st to sc.y-st*2 step st+1
'    select case sw
'        case 0
'            sw = 1
'        case 1
'            sw = 0
'    end select
    
    for xx as integer = st to sc.x-st*2 step st+1
        select case sw
        case 0
            line(xx,yy)-(xx+st,yy+st),rgb(200,200,200),bf
            line(xx,yy)-(xx+st,yy+st),rgb(150,150,150),b
            sw = 1
        case 1
            line(xx,yy)-(xx+st,yy+st),rgb(128,128,128),bf
            line(xx,yy)-(xx+st,yy+st),rgb(100,100,100),b
            sw = 0
        end select
    next xx
next yy

sleep