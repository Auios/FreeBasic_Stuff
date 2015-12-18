#include "fbgfx.bi"
using fb

print "Use the WASD keys to control the pixel!"
print "Press R to restart the program!"

declare sub resetprogram

dim shared as integer scrnx,scrny
    scrnx = 800
    scrny = 600
screenres 800,600,16,2,0

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
const pi = atn(1)*4
dim shared as double col

debug = 0
gravitytoggle=0

tail=1

a=0
theta = a*pi/180
turnspeed = 1

speed = .1
addspeed = pi
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
    a=360*rnd
    theta = a*pi/180
    speed = .5
    
    scx=cos(theta)
    scy=sin(theta)
    
    velx=speed*scx
    vely=speed*scy
end sub

resetprogram

do
    screenlock
    line(0,0)-(90,30),23,"bf"
    draw string(5,5),"theta: " & a
    draw string(5,15),"Speed: " & int(speed)
    if tail = 0 then cls
    line(x(1),y(1))-(x(2),y(2)),rgb((200*rnd)+55,(200*rnd)+55,(200*rnd)+55)
    pset(x(2),y(2)),rgb((200*rnd)+55,(200*rnd)+55,(200*rnd)+55)
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
    if multikey(sc_w) then speed+=addspeed
    if multikey(sc_s) then
        if speed >=.1 then speed-=addspeed
    end if
    
    if multikey(sc_r) then resetprogram
    
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