#include "fbgfx.bi"
using fb

declare sub resetgame

dim shared as integer scrnx,scrny
screenres 800,600,8,2,0
screeninfo scrnx,scrny

dim shared as integer mouseresult,click1,mox,moy

dim shared as integer debug = 0
dim shared as double speed,angle,a
dim shared as integer turnspeed = 2
dim shared as double scx,scy
dim shared as double velx,vely
dim shared as double x(1 to 2),y(1 to 2)
dim shared as double pi = 3.14159265358979

a=0
angle = a*pi/180
speed = .1

scx=cos(angle)
scy=sin(angle)

velx=speed*scx
vely=speed*scy

sub resetgame
    for i as integer = 1 to 2
        x(i)=scrnx/2
        y(i)=scrny/2
    next
    
    cls
    a=0
    angle = a*pi/180
    speed = .1
    
    scx=cos(angle)
    scy=sin(angle)
    
    velx=speed*scx
    vely=speed*scy
end sub

resetgame

do
    screenlock
    'line(0,0)-(90,30),23,"bf"
    'draw string(5,5),"Angle: " & a
    'draw string(5,15),"Speed: " & speed
    cls
    line(x(1),y(1))-(x(2),y(2)),15
    screenunlock
    
    if x(2) < 0 then x(2) = scrnx
    if y(2) < 0 then y(2) = scrny
    if x(2) > scrnx then x(2) = 0
    if y(2) > scrny then y(2) = 0
    
    if multikey(sc_a) then
        a-=turnspeed
        angle=a*pi/180
        if a < 0 then a = 360
    end if
    if multikey(sc_d) then
        a+=turnspeed
        angle=a*pi/180
        if a > 360 then a = 0
    end if
    if multikey(sc_w) then speed+=.1
    if multikey(sc_s) then
        if speed >=.1 then speed-=.1
    end if
    
    if multikey(sc_r) then resetgame
    
    scx=cos(angle)
    scy=sin(angle)
    velx=speed*scx
    vely=speed*scy
    
    x(1)=x(2)
    y(1)=y(2)
    
    x(2)=x(2)+velx
    y(2)=y(2)+vely
    
    mouseresult=getmouse(mox,moy,click1)
    
    sleep 15
loop until multikey(sc_escape)