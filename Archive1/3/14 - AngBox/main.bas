#include "fbgfx.bi"
using fb
randomize timer

const pi = atn(1)*4


sub AngBox(x as single,y as single,size as single,ang as single)
    ang = ang mod 360
    size/=2
    var theta = ang*pi/180
    line(x-size*cos(theta),y+size*sin(theta))-(x+size*cos(theta),y-size*sin(theta))
end sub

dim shared as integer scrnx,scrny
scrnx = 800
scrny = 600
screenres scrnx,scrny,16,2,0

dim shared as single angle

do
    angle += 1
    angle = angle mod 360
    
    screenlock
    cls
    print angle
    
    AngBox(scrnx/2,scrny/2,100,angle)
    AngBox(scrnx/2,scrny/2,100,angle+15)
    AngBox(scrnx/2,scrny/2,100,angle+15*2)
    AngBox(scrnx/2,scrny/2,100,angle+15*3)
    AngBox(scrnx/2,scrny/2,100,angle+15*4)
    AngBox(scrnx/2,scrny/2,100,angle+15*5)
    AngBox(scrnx/2,scrny/2,100,angle+15*6)
    AngBox(scrnx/2,scrny/2,100,angle+15*7)
    AngBox(scrnx/2,scrny/2,100,angle+15*8)
    AngBox(scrnx/2,scrny/2,100,angle+15*9)
    AngBox(scrnx/2,scrny/2,100,angle+15*10)
    AngBox(scrnx/2,scrny/2,100,angle+15*11)
    screenunlock
    
    sleep 10
loop until multikey(sc_escape)