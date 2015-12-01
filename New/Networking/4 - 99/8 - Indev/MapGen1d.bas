'Perlin Noise 1D
#include "fbgfx.bi"
#include "scrn.bas"
using fb

randomize timer

scrn()

dim as integer y

for x as integer = 0 to sc.x
    y = sc.y/2 '<Insert secret formula here
    
    pset(x,y)
next x

sleep