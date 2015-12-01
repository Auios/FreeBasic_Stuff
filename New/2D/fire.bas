#include "auios/auios.bi"
#include "fbgfx.bi"

randomize timer

using auios

type fire
    as integer x,y
    as integer distance
    as byte ty
end type

dim shared as integer i,k,movechoice,startY = 300,startX = 300
dim shared as AuWindow wnd
dim shared as fire fr(1 to 300)

wnd = AuWindowInit(800,600,"Application",32,1,0)
AuWindowCreate(wnd)

for i = lbound(fr) to ubound(fr)
    with fr(i)
        .x = startX*rnd
        .y = StartY*rnd
        .ty = 255*rnd
    end with
next i

do
    screenlock
    line(0,0)-(800,600),rgb(90,10,10),bf
    for i = lbound(fr) to ubound(fr)
        with fr(i)
            .y-=1
            .distance+=1
            if .y > 200 then
                if .distance > 25 then
                    k = 40*rnd+1
                    if k = 1 then
                        .y = StartY*rnd
                        .x = StartX*rnd
                    end if
                end if
            else
                .y = StartY*rnd
                .x = StartX*rnd
            end if
            
            '<^^^>
            movechoice = 9*rnd+1
            select case moveChoice
            case is < 4
                .x-=1
            case is > 4
                .x+=1
            end select
            
            draw string(.x,.y),chr(.ty),rgb(255,100,100)
            'locate(.y,.x):print("X")
        end with
    next i
    screenunlock
    
    sleep 20,1
loop until inkey = chr(27)

end AuWindowDestroy(wnd)