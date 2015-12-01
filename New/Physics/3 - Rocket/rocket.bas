#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny
screenres 800,600,8,2,0
screeninfo scrnx,scrny

dim shared as integer x1,x2,y1,y2
dim shared as integer tail
dim shared as integer theta,a
dim shared as double accelx,accely
dim shared as double fx,fy,mass
dim shared as double velx,vely,velocity
dim shared as double thrust,gravity
dim shared as double timescale,loops
dim shared as double pi=3.14159265358979

a=90
theta = a*pi/180
gravity = -.3

mass=3

timescale = .2

x2=scrnx/2
y2=scrny/2

accely=((thrust-(mass*gravity))/(mass*sin(theta)))
accelx=(thrust/(mass*cos(theta)))

y2=y2+vely*timescale+.5*accely*timescale^2
x2=x2+velx*timescale+.5*accelx*timescale^2

velx=velx+accelx*timescale
vely=vely+accely*timescale

x2=x2+velx
y2=y2+vely

tail = 0

do
    screenlock
    
    if tail = 0 then cls
    
    line(0,0)-(120,110),23,"bf"
    draw string(5,5),"Theta: " & int(a)
    draw string(5,15),"Speed: " & int(velocity)
    draw string(5,25),"Thrust: " & int(thrust)
    draw string(5,35),"Time: " & int(timescale)
    draw string(5,45),"Velx: " & int(velx)
    draw string(5,55),"Vely: " & int(vely)
    draw string(5,65),"Accelx: " & int(accelx)
    draw string(5,75),"Accely: " & int(accely)
    draw string(5,85),"X2: " & int(x2)
    draw string(5,95),"Y2: " & int(y2)
    
    if x2 < 0 then x2 = scrnx
    if y2 < 0 then y2 = scrny
    if x2 > scrnx then x2 = 0
    if y2 > scrny then y2 = 0
    
    line(x1,y1)-(x2,y2),15
    'pset(x2,y2),15
    screenunlock
    
    x1=x2
    y1=y2
    
    theta = a*pi/180
    accely=((thrust-(mass*gravity))/(mass*sin(theta)))
    accelx=(thrust/(mass*cos(theta)))
    
    velx=velx+accelx*timescale
    vely=vely+accely*timescale
    
    y2=y2+vely*timescale+.5*accely*timescale^2
    x2=x2+velx*timescale+.5*accelx*timescale^2
    
    x2=x2+velx
    y2=y2+vely
    
    if vely > 15 then vely = 15
    
    if multikey(sc_a) then
        a+=1
        if a > 360 then a = 0
    end if
    if multikey(sc_d) then
        a-=1
        if a < 0 then a = 360
    end if
    
    if multikey(sc_w) and thrust < -gravity*2 then
        thrust+=.5
    else
        thrust = 0
    end if
    
    sleep 100
'    if loops>50 then
'        loops=0
'        timescale+=1
'    end if
loop until multikey(sc_escape)