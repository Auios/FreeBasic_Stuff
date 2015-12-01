#include "fbgfx.bi"
#include "scrn.bas"
using fb

randomize 1

scrn(800,600,32,2,0,"Working Pages")

screenset 1,0

circle(50,50),20
print "Finished..."

screensync

sleep

screencopy

sleep