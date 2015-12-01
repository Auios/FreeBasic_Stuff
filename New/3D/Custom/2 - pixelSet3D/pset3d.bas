#include "fbgfx.bi"
using fb
randomize timer

dim shared as integer scrnx,scrny,xcen,ycen,zcen,fovx,fovy
screeninfo scrnx,scrny
screenres scrnx,scrny,16,2,1
'screenres 640,460,16

xcen=scrnx/3
ycen=scrny/3
zcen=256
fovx=zcen
fovy=zcen*100

Declare sub pset3d(x as integer, y as integer, z as integer, clr as integer)

sub pset3d(x as integer, y as integer, z as integer, clr as integer)
    pset(fovx*x/(z+zcen)+xcen,fovy*y/(z+zcen)+ycen),clr
end sub

dim as uinteger white=rgb(255,255,255),col=rgb(255*rnd,255*rnd,255*rnd)
dim as integer x,y,z,pitchspeed=15,xpl=250,zpl=250,spa=1

do
    if multikey(sc_w) then zpl-=pitchspeed
    if multikey(sc_s) then zpl+=pitchspeed
    if multikey(sc_q) then xcen+=pitchspeed
    if multikey(sc_e) then xcen-=pitchspeed
    if multikey(sc_x) then ycen+=pitchspeed
    if multikey(sc_z) then ycen-=pitchspeed
    
    if multikey(sc_a) then xpl-=pitchspeed
    if multikey(sc_d) then xpl+=pitchspeed
    
    screenlock
    cls
    
    for x = -xpl to -xpl+500 step spa
        for y = 1 to 1 step 1
            for z = zpl to zpl+500 step spa
                pset3d(x,y,z,white)
            next
        next
    next
    screenunlock
    sleep 5
loop until multikey(sc_escape)
sleep