#include "fbgfx.bi"
#include "scrn.bas"
using fb

randomize timer

dim shared as uinteger sz = 1

sub loadImage()
    dim as uinteger buffer
    
    var filename = "img.txt"
    var ff = freefile
    
    open filename for input as #ff
    dim as uinteger sx,sy,sz
    
    input #ff,sx,sy,sz
    
    scrn(sx,sy)
    
    for x as integer = 0 to sc.x-1
        for y as integer = 0 to sc.y-1
            input #ff,buffer
            line(x,y)-(x+sz,y+sz),buffer,"bf"
        next y
    next x
    
    close #ff
end sub

loadImage()

sleep