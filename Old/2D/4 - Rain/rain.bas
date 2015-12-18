#include "fbgfx.bi"
using fb
randomize timer
dim shared as const integer true=1,false=0

dim shared as integer scrnx,scrny
scrnx = 800
scrny = 600
screenres scrnx,scrny,16,2,0

dim as integer x,y
dim as double delay
dim as integer frequency,chance

delay=.5
frequency=500
chance=frequency*rnd

do
    screenlock
    if chance = 1 then line(x,y)-(x+100*rnd,y+3*rnd),RGB(255,255,255)
    
    line(0,0)-(100,35),RGB(0,0,255),"bf"
    draw string(5,5),"X: " & x,RGB(255,255,255)
    draw string(5,15),"Y: " & y,RGB(255,255,255)
    draw string(5,25),"Chance: " & chance,RGB(255,255,255)
    screenunlock
    
    chance=frequency*rnd
    
    x+=1
    if x>scrnx then
        x=0
        y+=1
        if y>scrny then y=0
    end if
loop until multikey(sc_escape)