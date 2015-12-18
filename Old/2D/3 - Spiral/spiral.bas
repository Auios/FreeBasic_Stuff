#include "fbgfx.bi"
using fb

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
scrnx = 640
scrny = 480

screenres scrnx,scrny,16,2,0

dim shared as double x0,y0,x1,y1

const pi = atn(1)*4
dim as double angle,i,freq
dim as integer size

print "-------------------------------"
print "Cca's shitty spiral program! :D"
print "-------------------------------"
print
print "Size: How big the spiral will be. Ex #: 1000"
input size
print
print "Update Frequency: The detail of it. Lower = More detail Ex #: .01, High = Less detail. Ex #: 5"
input freq
cls

screenlock
for i = 0 to size step freq
        angle = 0.1 * i
        x0=(1+angle)*cos(angle)
        y0=(1+angle)*sin(angle)
        
        
        Line((scrnx/2)+x0,(scrny/2)-y0)-((scrnx/2)+x1,(scrny/2)-y1),rgb(255,255,255)
        
        x1 = x0
        y1 = y0
next
screenunlock
sleep