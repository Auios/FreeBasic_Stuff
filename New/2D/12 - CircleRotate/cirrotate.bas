'Cca's Circle Rotation Fun Program Source
#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
'screeninfo scrnx,scrny
scrnx = 800
scrny = 600
screenres scrnx,scrny,16,2,0

const pi = atn(1)*4     'Pi = nTan(1)*4

type player
    as double x
    as double y
    as string nme
    as uinteger clr
    as integer turnspeed = 3
    as double angle
    as double theta
    as integer radius = 15
    as string id
    as integer action
end type
dim shared as player pl

sub controls(pl as player)          'Sub for controlling the entity
    select case pl.id
    case "WASD"
        if multikey(sc_a) then
            pl.angle+=pl.turnspeed
            pl.theta = pl.angle*pi/180
            if pl.angle > 360 then pl.angle = 0
        end if
        
        if multikey(sc_d) then
            pl.angle-=pl.turnspeed
            pl.theta = pl.angle*pi/180
            if pl.angle < 0 then pl.angle = 360
        end if
        
        if multikey(sc_w) then
            pl.x+=2*cos(pl.theta)
            pl.y-=2*sin(pl.theta)
        end if
        
        if multikey(sc_s) then
            pl.x-=2*cos(-pl.theta)
            pl.y-=2*sin(-pl.theta)
        end if
    end select
end sub

sub drawplayer(pl as player)                                            'Render
    line(pl.x,pl.y)-(pl.x+pl.radius*cos(pl.theta),pl.y-pl.radius*sin(pl.theta)),pl.clr
    circle(pl.x,pl.y),pl.radius,pl.clr
    
    draw string(5,5),"" & pl.angle
end sub

sub collision(p11 as player,p22 as player)                      'Collision detection (Not working)
    dim as integer isTouching
    if p11.x+p11.radius >= p22.x-p22.radius then isTouching=1
    if p11.x-p11.radius <= p22.x+p22.radius then isTouching=1
    if p11.y-p11.radius <= p22.y+p22.radius then isTouching=1
    if p11.y+p11.radius >= p22.y-p22.radius then isTouching=1
    if isTouching = 1 then
        sleep
    end if
    isTouching=0
end sub

dim shared as integer delay = 20

dim shared p1 as player
p1.id = "WASD"
p1.clr = rgb(255,0,0)
p1.x = scrnx*rnd
p1.y = scrny*rnd
dim shared p2 as player
p2.id = "ARROWS"
p2.clr = rgb(0,0,255)
p2.x = scrnx*rnd
p2.y = scrny*rnd

do                                  'The loop
    controls(p1)
'    controls(p2)
    
    
'    collision(p1,p2)
'    collision(p2,p1)
    
    screenlock
    cls
    
'    line(0,0)-(100,15),col.blue,"bf"
'    draw string(5,5),"Theta: " & int(pl.angle),col.white
    
    drawplayer(p1)
    screenunlock
    
    sleep delay
loop until multikey(sc_escape)