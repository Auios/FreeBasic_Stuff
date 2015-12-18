#include "fbgfx.bi"
using fb

dim shared as integer scrnx,scrny,swi

swi = 1

if swi = 1 then
    screeninfo scrnx,scrny
    screenres scrnx,scrny,16,1,1
else
    scrnx = 640
    scrny = 480
    screenres scrnx,scrny,16,1,0
end if

dim shared as integer code = 1,dyu = 1
dim shared as integer x,y,r,t,rad,spd
dim shared as integer i,j

rad = 5
r = 15
spd = 0

do
    screenlock
    for i = 0 to scrnx' step rad*2
        for j = 0 to scrny' step rad*2
            pset(i,j),rgb(i+x*r,j+y*t,(i+x+j+y)*r)
        next
    next
    screenunlock
    
    if multikey(sc_d) then x+=1
    if multikey(sc_a) then x-=1
    if multikey(sc_w) then y+=1
    if multikey(sc_s) then y-=1
    
    if multikey(sc_up) then r+=1
    if multikey(sc_down) then r-=1
    if multikey(sc_escape) then stop
    
    sleep spd
loop until multikey(sc_escape)

sleep