#include "fbgfx.bi"
 
sub DrawBoxes(pTarget as any ptr=0)
  randomize 33
  for CNT as integer = 0 to 1000
    var iX = rnd*640, iY = rnd*480
    line pTarget,(iX,iY)-(iX+rnd*64,iY+rnd*64),rgb(rnd*255,rnd*255,rnd*255),bf
  next CNT
end sub
 
' ******* 32 BPP ******
screenres 640,480,32,,fb.gfx_HIGH_PRIORITY
 
var pBack = ImageCreate(640,480)
var pSphere = cast(fb.image ptr,ImageCreate(400,400,rgba(255,0,255,0)))
var pPix1 = cast(ulong ptr,pSphere+1)
for Y as integer = -200 to 199
  var iYY = Y*Y
  for X as integer = -200 to 199
    var iRad = sqr(X*X+iYY)
    if iRad <= 200 then      
      var iRad2 = (iRad*iRad)\128
      if iRad2 > 255 then iRad2 = 255
      *pPix1 = rgba(0,0,0,255-iRad2)      
    end if
    pPix1 += 1
  next X
next Y
 
DrawBoxes(pBack)
dim as integer X = 320-200,Y=240-200,SX=2,SY=2
do
  screenlock
  put(0,0),pBack,pset
  put(X,Y),pSphere,alpha  
  screensync
  screenunlock
 
  X=X+SX:Y=Y+SY
  if X = -100 or X = 640-300 then SX = -SX
  if Y = -100 or Y = 480-300 then SY = -SY
loop until len(inkey)