#include "fbgfx.bi"
 
sub DrawBoxes()
  randomize 33
  for CNT as integer = 0 to 1000
    var iX = rnd*640, iY = rnd*480
    line(iX,iY)-(iX+rnd*64,iY+rnd*64),rgb(rnd*255,rnd*255,rnd*255),bf
  next CNT
end sub
 
' ******* 32 BPP ******
screenres 640,480,32
 
var pSphere = ImageCreate(128,128)
var pImage1 = cast(fb.image ptr,ImageCreate(400,400,rgba(255,0,255,0)))
var pPix1 = cast(ulong ptr,pImage1+1)
var pImage2 = cast(fb.image ptr,ImageCreate(400,400,rgba(255,0,255,0)))
var pPix2 = cast(ulong ptr,pImage2+1)
for Y as integer = -200 to 199
  var iYY = Y*Y
  for X as integer = -200 to 199
    var iRad = sqr(X*X+iYY)
    if iRad <= 200 then      
      var iRad2 = (iRad*iRad)\128
      if iRad2 > 255 then iRad2 = 255
      *pPix1 = rgba(0,0,0,255-iRad2)
      *pPix2 = rgba(200-iRad,200-iRad,200-iRad,iRad+55)
    end if
    pPix1 += 1: pPix2 += 1
  next X
next Y
circle pImage1,(200,200),199,rgb(255,255,255)
 
DrawBoxes()
' Draw Pseudo sphere on left/top
for CNT as integer = 0 to 200
  circle(64,64),50-(CNT\4),rgb(CNT,CNT,CNT),,,,f
  circle pSphere,(64,64),50-(CNT\4),rgb(CNT,CNT,CNT),,,,f
next CNT
 
put(320-200,240-200),pImage1,alpha
put(639-128,0),pSphere,alpha,192
sleep
 
DrawBoxes()
put(320-200,240-200),pImage2,alpha
put(639-128,0),pSphere,alpha,192
put(0,0),pSphere,trans
sleep
 
put(320-200,240-200),pImage2,trans
sleep