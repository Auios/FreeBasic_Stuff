#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,1,1

dim shared as integer j = 2500
dim shared as integer x(1 to j),y(1 to j)

do
    screenlock
    cls
    screenunlock
    
    for i as integer = 1 to j
        if multikey(sc_escape) then exit for
        x(i)=scrnx*rnd
        y(i)=scrny*rnd
        sleep 1
        
        screenlock
        draw string(x(i),y(i)),chr(5000*rnd),rgb(255*rnd,255*rnd,255*rnd)
        screenunlock
    next
    
    sleep 100
loop until multikey(sc_escape)