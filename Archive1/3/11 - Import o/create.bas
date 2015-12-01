#include "fbgfx.bi"
 
screenres 640,480
 
var pImage = cast(fb.image ptr,ImageCreate(128,128))
 
for CNT as integer = 0 to 1000
  line pImage,(rnd*128,rnd*128)-(rnd*128,rnd*128),rnd*255
next CNT
 
put(0,0),pImage,pset
 
var f = freefile()
open "gfxbuffer.img" for binary access write as #f
put #f,,*cptr(ubyte ptr,pImage),(pImage->Pitch*pImage->Height*pImage->Bpp)+sizeof(fb.image)
close #f

screen 0