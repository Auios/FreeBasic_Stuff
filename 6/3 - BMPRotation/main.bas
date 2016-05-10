#include "fbgfx.bi"
'#include "auLib.bi"
#include "rotateScale.bas"

'using fb , auios

'dim as AuWindow wnd
dim as any ptr img
dim as short x,y,sz,rot

x = 50
y = 50
sz = 256
rot = 0

'wnd = AuWindowSet()
'AuWindowCreate(wnd)
screenres 800,600,32,1,fb.GFX_HIGH_PRIORITY

img = imageCreate(sz,sz, rgba(255,0,255,0))
bload("256.bmp",img)

'put(x,y),img
rotateScalehq(,img,x+sz/2,x+sz/2,5,1)
line(x,y)-(x+sz,y+sz),,b

do
    cls
    print rot
    rot+=1
    rot = rot mod 360
    line(x,y)-(x+sz,y+sz),,b
    rotateScalehq(,img,x+sz/2,x+sz/2,rot,1)
    
    sleep(10,1)
loop until(multikey(fb.sc_escape))

imagedestroy(img)

sleep()

