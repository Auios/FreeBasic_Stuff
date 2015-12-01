#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
scrnx = 800
scrny = 600
screenres scrnx,scrny,8,2,0

dim shared as integer top = 58                                                  '0 and 58 lag behind. Don't know why.

dim as integer x(top)
dim as integer y(top)

for i as integer = 0 to top
    y(i)=(10*i)+10
next i

do
    dim as integer sl = top*rnd
    for i as integer = 0 to top
        if sl = i then
            x(i)+=1
            if x(i) >= scrnx then
                for j as integer = 0 to top
                    x(j) = 0
                next j
            end if
        end if
    next i
    
    screenlock
    cls
    line(scrnx,0)-(x(sl),y(sl)),rgb(255*rnd,255*rnd,255*rnd)
    draw string(scrnx*rnd,scrny*rnd),"Pew!"
    
    for i as integer = 0 to top
        line(0,y(i))-(x(i),y(i)+5),,"bf"
        draw string(x(i)+5,y(i)),i & ": " & x(i)
    next i
    screenunlock
    sleep 1
loop until multikey(sc_escape)
