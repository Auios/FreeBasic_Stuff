screenres 640,480
 
var f = freefile()
open "gfxbuffer.img" for binary access read as #f
var iSz = lof(f)
var pImage = allocate(iSz)
get #f,,*cptr(ubyte ptr,pImage),iSz
close #f
 
put(10,10),pImage,pset
 
sleep

screen 0