#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,1

dim as integer particles=25
dim as double middle(1 to particles),change=.1
dim as double u(1 to particles)
dim as integer x(1 to particles),y(1 to particles),o=0,delay=1
dim as uinteger c(1 to particles)

for j as integer = 1 to particles
    middle(j)=50
    c(j)=rgb(255*rnd,255*rnd,255*rnd)
next

do
    for i as integer = 1 to particles
        u(i)=100*rnd
        if u(i) > middle(i) then
            middle(i)-=change
            y(i)+=1
        elseif u(i) < middle(i) then
            middle(i)+=change
            y(i)-=1
        elseif int(u(i)) = int(middle(i)) then
            x(i)+=1
            screenlock
            pset(x(i),scrny/2+y(i)),c(i)
            screenunlock
        end if
        
        x(i)+=1
        if x(i) > scrnx*1.5 then
            screenlock
            cls
            screenunlock
            x(i)=0
            y(i)=0
            middle(i) = 50
        end if
        
        screenlock
        pset(x(i),scrny/2+y(i)),c(i)
        
    '    line(0,0)-(90,35),rgb(100,100,100),"bf"
    '    draw string(5,5),"X: " & x,rgb(255,255,255)
    '    draw string(5,15),"Y: " & y,rgb(255,255,255)
    '    draw string(5,25),"Middle: " & int(middle),rgb(255,255,255)
        screenunlock
    next
    o+=1
    
    sleep delay
loop until multikey(sc_escape)