#include "fbgfx.bi"
'include "color16.bi"
#include "string.bi"
using fb

dim shared as integer scrnx,scrny
screeninfo scrnx,scrny
scrnx = 800
scrny = 600

screenres scrnx,scrny,16,2,0

dim shared as double x0,y0,x1,y1

const pi = atn(1)*4
dim as double angle,i,freq,req,lop,iu
dim as integer size

size = 150
freq = 0.5
req = 0
lop = 0.05
iu = 25


for i = 0 to size step freq
        angle = lop * i
        x0=(req+angle)*cos(angle)*iu
        y0=(req+angle)*sin(angle)*iu
        
        
        Line((scrnx/2)+x0,(scrny/2)-y0)-((scrnx/2)+x1,(scrny/2)-y1)
        line(0,0)-(65,25),rgb(0,0,255),"bf"
'        draw string(5,5),"x: " & format(0,0.00)
'        draw string(5,15),"y: " & y0
        
'        sleep
        if multikey(sc_escape) then stop
        
        x1 = x0
        y1 = y0
next
sleep