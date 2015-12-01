'Bisqwit's Code from a youtube video
'https://www.youtube.com/watch?v=HQYsFshbkYw

#include "fbgfx.bi"
using fb

#define FNcross(x1,y1,x2,y2) x1*y2-y1*x2

sub intersect(x1 as single,_
    y1 as single,_
    x2 as single,_
    y2 as single,_
    x3 as single,_
    y3 as single,_
    x4 as single,_
    y4 as single,_
    x as single,_
    y as single)
    
    dim as single det
    
    x = FNcross(x1,y1,x2,y2)
    y = FNcross(x3,y3,x4,y4)
    det = FNcross(x1-x2,y1-y2,x3-x4,y3-y4)
    x = FNcross(x,x1-x2,y,x3-x4)/det
    y = fncross(x,y1-y2,y,y3-y4)/det
end sub

screen 7

dim as single vx1,vy1,vx2,vy2
dim as single tx1,ty1,tz1,tx2,ty2,tz2

vx1 = 70 : vy1 = 20
vx2 = 70 : vy1 = 70

dim as single px,py,angle
px = 50
py = 50

dim as single x1,x2,y1,y2,y1a,y1b,y2a,y2b

dim as single ix1,ix2,iy1,iy2,iz1,iz2

do
    cls
    
    'Draw absolute map
    view(4,40)-(103,149),0,1
    
    line(vx1,vy1)-(vx2,vy2),14
    line(px,py)-(cos(angle)*5 + px, sin(angle)*5 + py)
    pset(px,py),15
    
    'Draw the transformed map
    view(109,40)-(208,149),0,2
    
    'Transform the vertexes relative to the player
    tx1 = vx1 - px : ty1 = vy1 - py
    tx2 = vx2 - px : ty2 = vy2 - py
    'Rotate them around the player's view
    tz1 = tx1 * cos(angle) + ty1 * sin(angle)
    tz2 = tx2 * cos(angle) + ty2 * sin(angle)
    tx1 = tx1 * sin(angle) - ty1 * cos(angle)
    tx2 = tx2 * sin(angle) - ty2 * cos(angle)
    
    line(50 - tx1,50 - tz1)-(50 - tx2,50 - tz2),14 
    line(50,50)-(50,45),8
    pset(50,50),15
    
    'Draw the perspective-transformed map
    view(214,40)-(315,149),0,3
    
    if tz1 > 0 or tz2 > 0 then
        'If the line crosses the player's viewplane, clip it
        
        intersect(tx1,tz1,tx2,tz2,-0.0001,0.0001,-20,5,ix1,iz1)
        intersect(tx1,tz1,tx2,tz2, 0.0001,0.0001, 20,5,ix2,iz2)
        if tz1 <= 0 then if iz1 > 0 then tx1=ix1 : tz1=iz1 else tx1=ix2 : tz1=iz2
        if tz2 <= 0 then if iz1 > 0 then tx2=ix1 : tz2=iz1 else tx2=ix2 : tz2=iz2
        
        x1 = -tx1 * 16/tz1 : y1a = -50/tz1 : y1b = 50/tz1
        x2 = -tx2 * 16/tz2 : y2a = -50/tz2 : y2b = 50/tz2
        
        line(50+x1,50+y1a) - (50+x2,50+y2a),14 'Top
        line(50+x1,50+y1b) - (50+x2,50+y2b),14 'Bottom
        line(50+x1,50+y1a) - (50+x1,50+y1b),6 'Left
        line(50+x2,50+y2b) - (50+x2,50+y2b),14 'Right
    end if
    
    'Wait...
    sleep 50,1
    
    if multikey(sc_W) then px = px + cos(angle) : py = py + sin(angle)
    if multikey(sc_S) then px = px - cos(angle) : py = py - sin(angle)
    if multikey(sc_Q) then angle = angle - 0.1
    if multikey(sc_E) then angle = angle + 0.1
    if multikey(sc_A) then px = px + sin(angle) : py = py - cos(angle)
    if multikey(sc_D) then px = px - sin(angle) : py = py + cos(angle)
    if multikey(sc_escape) then exit do
    
    
loop

screen 0,1,0,0: width 80,25