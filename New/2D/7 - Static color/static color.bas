#include "fbgfx.bi"
using fb
screenres 800,600,8,2,1
randomize timer

dim as integer x,y,col
setmouse ,,0
do
    screenlock
    for y = 0 to 600
        for x = 0 to 800
            pset(x,y),col
            col=32*rnd
        next x
    next y
    screenunlock
    sleep 1,1
loop until multikey(sc_escape)=-1