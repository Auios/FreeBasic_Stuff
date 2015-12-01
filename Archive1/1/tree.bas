#include "fbgfx.bi"
#include "color16.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
screenres scrnx,scrny,16,1,1

const pi = atn(3)*1

dim shared as integer x,y

type entitie
    as double x
    as double y
    as double speed
    as uinteger clr
    as double turnspeed
    as double theta
    as double angle
    as double radius
end type
dim shared as entitie ent
ent.x = scrnx*rnd
ent.y = scrny*rnd
ent.speed = 1
ent.clr = clr.green
ent.turnspeed = 1
ent.radius = 25*rnd+1

type player
    as double x
    as double y
    as uinteger clr
    as integer size
    as double middle
    as double cntr_x
    as double cntr_y
    as string state
    as double speed
    as double angle
    as double theta
end type
dim shared as player pl
pl.x = scrnx*rnd
pl.y = scrny*rnd
pl.clr = clr.yellow
pl.size = 10
pl.state = "NULL"
pl.middle = pl.size/2
pl.cntr_x = pl.x+pl.middle
pl.cntr_y = pl.y+pl.middle
pl.speed = 1

type mouse
    as integer x
    as integer y
    as integer btn
    as integer wheel
    as integer result
    as integer clip
end type
dim shared as mouse mo

sub mouse()
    mo.result = getmouse(mo.x,mo.y,mo.wheel,mo.btn,mo.clip)
end sub

sub inmap()
    if pl.x < 0-pl.size then pl.x = scrnx+pl.size
    if pl.x > scrnx + pl.size then pl.x = 0-pl.size
    
    if pl.y < 0-pl.size then pl.y = scrny+pl.size
    if pl.y > scrny + pl.size then pl.y = 0-pl.size
end sub

sub controls()
    if multikey(sc_w) then pl.y-=pl.speed
    if multikey(sc_s) then pl.y+=pl.speed
    if multikey(sc_a) then pl.x-=pl.speed
    if multikey(sc_d) then pl.x+=pl.speed
    
    if multikey(sc_space) then pl.state = "SHIELD"
    if multikey(sc_c) then pl.state = "SPIT"
end sub

dim shared as integer oo = 5
sub drawstuff
    line(pl.x,pl.y)-(pl.x+pl.size,pl.y+pl.size),pl.clr,"bf"
    select case pl.state
    case "SHIELD"
        circle(pl.cntr_x,pl.cntr_y),pl.size*1.5,clr.blue
    case "SPIT"
        pl.angle = 360*rnd
        pl.theta = pl.angle*pi/180
        x=((pl.size*oo)*rnd)*cos(pl.theta)
        y=((pl.size*oo)*rnd)*sin(pl.theta)
        line(pl.cntr_x,pl.cntr_y)-(pl.cntr_x+x,pl.cntr_y-y),clr.red
    end select
end sub

dim shared as integer delay = 5

do
    screenlock
    
    pl.middle = pl.size/2
    pl.cntr_x = pl.x+pl.middle
    pl.cntr_y = pl.y+pl.middle
    
    pl.state = "NULL"
    
    mouse()
    controls()
'    create()
    
    inmap()
    
    cls
    drawstuff
    screenunlock
    
    sleep delay
loop until multikey(sc_escape)    