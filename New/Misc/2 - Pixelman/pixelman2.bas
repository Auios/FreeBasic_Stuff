#include "fbgfx.bi"
using fb

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,1

dim shared as integer delay=50

type screendata
    as integer north    = 0
    as integer south    = scrny
    as integer east     = 0
    as integer west     = scrnx
end type
dim shared scr as screendata

type colors
    as uinteger white   = rgb(255,255,255)
    as uinteger black   = rgb(0,0,0)
    as uinteger red     = rgb(255,0,0)
    as uinteger green   = rgb(0,255,0)
    as uinteger blue    = rgb(0,0,255)
end type
dim shared col as colors

'screenlock
'for q as integer = 0 to scrnx
'    for w as integer = 0 to scrny
'        pset(q,w),col.black
'    next
'next
'screenunlock

sub randomline(max as integer)
    dim as integer x1,y1,x2,y2,dice=2*rnd
    x1=scrnx*rnd
    y1=scrny*rnd
    select case int(dice)
    case 0
        x2=x1+((max*rnd)-max/2)
        y2=y1+((max*rnd)-max/2)
        line(x1,y1)-(x2,y2),col.white
    case 1
        x2=x1-((max*rnd)-max/2)
        y2=y1-((max*rnd)-max/2)
        line(x1,y1)-(x2,y2),col.white
    end select
end sub

sub movecon(byref x as integer,byref y as integer,speed as integer)
    if multikey(sc_w) and y-speed > scr.north and point(x,y-speed)=0 then y-=speed
    if multikey(sc_s) and y+speed > scr.south and point(x,y+speed)=0 then y+=speed
    if multikey(sc_d) and x+speed > scr.east and point(x-speed,y)=0 then x+=speed
    if multikey(sc_a) and x-speed > scr.west and point(x+speed,y)=0 then x-=speed
end sub

sub player(x as integer,y as integer,col as uinteger)
  pset(x,y),col
end sub

sub display(x as integer,y as integer)
    line(0,0)-(70,25),col.blue,"bf"
    draw string(5,5), "x: "&x,col.white
    draw string(5,15),"y: "&y,col.white
end sub

type player
    as integer x
    as integer y
    as integer scale
    as integer speed
end type
dim pl as player

pl.speed=1
pl.x=scrnx/2
pl.y=scrny/2

do
    movecon(pl.x,pl.y,pl.speed)
    
    
    screenlock
    cls
    
    player(pl.x,pl.y,col.white)
    display(pl.x),(pl.y)
    'randomline(500*rnd)
    screenunlock
    
    sleep delay
loop until multikey(sc_escape)

screen 0