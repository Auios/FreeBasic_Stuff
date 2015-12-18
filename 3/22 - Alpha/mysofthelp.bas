#include "fbgfx.bi"
 
 randomize timer
 
sub DrawBoxes()
  randomize 33
  for CNT as integer = 0 to 1000
    var iX = rnd*640, iY = rnd*480
    line(iX,iY)-(iX+rnd*64,iY+rnd*64),rgb(rnd*255,rnd*255,rnd*255),bf
  next CNT
end sub
 
' ******* 32 BPP ******
screenres 640,480,32,,fb.GFX_ALPHA_PRIMITIVES
DrawBoxes()
circle(320,240),200,rgba(255,128,64,192),,,,f
sleep
 
' ******* 16 BPP workaround ******
screenres 640,480,16
DrawBoxes()
var p = ImageCreate(400,400)
circle p,(200,200),200,rgb(255,128,64),,,,f
put(320-200,240-200),p,alpha,192
sleep