#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny

screenres scrnx,scrny,16,2,1

dim as double x1,y1,x2,y2,spread=.5
dim as uinteger white=rgb(255,255,255),black=rgb(0,0,0),red=rgb(255,0,0),green=rgb(0,255,0),blue=rgb(0,0,255)
dim as integer mox,moy,moresult,mouse=0

do
    moresult=getmouse(mox,moy)
    
    y1=tan(x1)+y1
    
    select case mouse
    case 0
        line((scrnx/2)+x2,(scrny/2)-y2)-((scrnx/2)+x1,(scrny/2)-y1),rgb(255*rnd,255*rnd,255*rnd)
        line((scrnx/2)-x2,(scrny/2)+y2)-((scrnx/2)-x1,(scrny/2)+y1),rgb(255*rnd,255*rnd,255*rnd)
    case 1
        line(mox+x2,moy-y2)-(mox+x1,moy-y1),rgb(255*rnd,255*rnd,255*rnd)
        line(mox-x2,moy+y2)-(mox-x1,moy+y1),rgb(255*rnd,255*rnd,255*rnd)
    end select
    
    x2=x1
    y2=y1
    
    x1+=spread
    
    if x1>scrnx then
        cls
        x1=0
        spread+=.5
    end if
    
    sleep 1
    
loop until multikey(sc_escape)