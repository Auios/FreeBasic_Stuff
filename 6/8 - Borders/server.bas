#include once "wshelper.bi"
#include once "aulib.bi"

#include once "world.bas"
#include once "client.bas"

using aulib

randomize(4669)

dim as World w
w.generate(8)
w.save("./worldData.bin")

dim as AuWindow wnd
wnd = AuWindowInit()
AuWindowCreate(wnd)

var size = 16

for y as integer = 0 to w.size-1
    for x as integer = 0 to w.size-1
        dim as uinteger clr,index
        index = (y*w.size)+x
        if(w.tile[index].terrain = Terrain.grass) then
            clr = rgb(100,200,100)
        elseif(w.tile[index].terrain = Terrain.water) then
            clr = rgb(100,100,200)
        else
            print clr = rgb(255,0,255)
        end if
        
        circle(x*size+size,y*size+size),size/2,clr,,,,f
    next x
next y

hStart()

sleep()