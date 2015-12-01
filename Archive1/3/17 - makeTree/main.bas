#include "fbgfx.bi"
using fb

randomize timer

dim shared as integer scrnx,scrny
scrnx = 800
scrny = 600
screenres scrnx,scrny,16

sub makeTree(x as single,y as single,size as single)
    dim as single nx,ny
    nx = x
    ny = y+size
    line(x,y)-(x,y-size)
    line(x,y-size)-(x+(size/2),y-size-(size/2))
    line(x,y-size)-(x-(size/2),y-size-(size/2))
end sub

makeTree(scrnx/2,scrny/2,15)

sleep