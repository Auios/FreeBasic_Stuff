#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
'screenres 1600,900,32,2,1
'screenres 800,600,32,2,1
screenres 600,400,32,2,1
screeninfo scrnx,scrny

dim shared as integer m = 50
dim shared as integer x(1 to m),y(1 to m),char(1 to m)
dim shared as integer mox,moy,mobutton,mowheel,moresult
dim shared as integer target=0,alive(1 to m)
dim shared as integer delay = 1

for j as integer = 1 to m
    char(j) = 5000*rnd
    x(j) = scrnx*rnd
    y(j) = scrny*rnd
    alive(j)=1
next

do
    screenlock
    cls
    
    line(0,0) - (90,15),rgb(0,0,255),"bf"
    draw string(5,5),"Target: "&target,rgb(255,255,255)
    
    for i as integer = 1 to m
        draw string(x(i),y(i)),chr(char(i)),rgb(255,255,255)
    next
    if target <> 0 then 
        line(mox,moy) - (x(target),y(target)),rgb(255,255,255)
        
        if mobutton=1 then
            line(mox,moy) - (x(target),y(target)),rgb(255,0,0)
            draw string(x(target),y(target))," ",rgb(0,0,0)
            x(target) = scrnx*rnd
            y(target) = scrny*rnd
'            char(target) = 5000*rnd
            alive(target) = 0
            target = 0
        end if
    end if
    screenunlock
    
    if multikey(sc_up) and target < m then
        do
            target+=1
            if target > m then
                exit do
                target = 0
            end if
        loop until alive(target) = 1
        sleep 100,1
    end if
    if multikey(sc_down) and target > 1 then
        do
            target-=1
            if target < 0 then
                exit do
                target = 0
            end if
        loop until alive(target) = 1
        sleep 100,1
    end if
    
    moresult=getmouse(mox,moy,mowheel,mobutton)
    
    While multikey(sc_up): Wend
    while multikey(sc_down):wend
    sleep delay
loop until multikey(sc_escape)