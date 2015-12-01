dim as integer scrnx,scrny,depth,pitch,rate,driver

#include "fbgfx.bi"
using fb

screenres 640,480
screeninfo scrnx,scrny,depth,pitch,rate,driver

print "Screen X";scrnx
print "Screen Y";scrny
print "Depth";depth
print "Pitch";pitch
print "Rate";rate
print "Driver";driver
sleep
