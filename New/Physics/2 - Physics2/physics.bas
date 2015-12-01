#include "fbgfx.bi"
using fb

declare sub resetprogram
declare sub subgravity

dim shared as integer scrnx,scrny
screenres 800,600,8,2,0
screeninfo scrnx,scrny

dim shared as integer mouseresult,click1,mox,moy

dim shared as integer loops,timescale
dim shared as integer debug,gravitytoggle
dim shared as double speed,addspeed,gravity
dim shared as double theta,a
dim shared as integer turnspeed
dim shared as double scx,scy
dim shared as double velx,vely
dim shared as integer tail
dim shared as double x(1 to 2),y(1 to 2)
dim shared as double pi = 3.14159265358979

debug = 0
gravitytoggle=1

tail=1

a=0
theta = a*pi/180
turnspeed = 1

speed = .1
addspeed = .1
gravity = 1

scx=cos(theta)
scy=sin(theta)

velx=speed*scx
vely=speed*scy

sub resetprogram
    for i as integer = 1 to 2
        x(i)=scrnx/2
        y(i)=scrny/2
    next
    
    cls
    a=0
    theta = a*pi/180
    speed = .1
    
    scx=cos(theta)
    scy=sin(theta)
    
    velx=speed*scx
    vely=speed*scy
end sub
sub subgravity
    vely+=gravity
    if speed > addspeed then
        if speed < 0 then
            speed = 0
        else
            speed-=addspeed
        end if
    end if
end sub

resetprogram

do
    screenlock
    line(0,0)-(90,30),23,"bf"
    draw string(5,5),"theta: " & a
    draw string(5,15),"Speed: " & speed
    if tail = 0 then cls
    line(x(1),y(1))-(x(2),y(2)),15
    pset(x(2),y(2)),6
    screenunlock
    
    if x(2) < 0 then x(2) = scrnx
    if y(2) < 0 then y(2) = scrny
    if x(2) > scrnx then x(2) = 0
    if y(2) > scrny then y(2) = 0
    
    if multikey(sc_a) then
        a-=turnspeed
        theta=a*pi/180
        if a < 0 then a = 360
    end if
    if multikey(sc_d) then
        a+=turnspeed
        theta=a*pi/180
        if a > 360 then a = 0
    end if
    if multikey(sc_w) then speed+=addspeed*2
    if multikey(sc_s) then
        if speed >=0 then speed-=addspeed
    end if
    
    if multikey(sc_r) then resetprogram
    if gravitytoggle = 1 then subgravity
    
    scx=cos(theta)
    scy=sin(theta)
    velx=speed*scx
    vely=speed*scy
    
    x(1)=x(2)
    y(1)=y(2)
    
    x(2)=x(2)+velx
    y(2)=y(2)+vely
    
    mouseresult=getmouse(mox,moy,click1)
    if click1 = 2 then
        scx=mox
        scy=moy
    end if
    
    sleep 20
    
    loops+=1
    if loops>50 then
        timescale+=1
        loops=0
    end if
loop until multikey(sc_escape)