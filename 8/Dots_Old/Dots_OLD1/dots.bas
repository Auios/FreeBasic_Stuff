#include "fbgfx.bi"

#include "pnt.bi"
#include "dot.bi"
#include "region.bi"

'Constants
#define WORLD_SIZE 16
#define REGION_SIZE 32
#define PI 3.14159265359

'Short
#define IDX(x,y,l) (y*l)+x

'Colors
#define C_WHITE rgb(255, 255, 255)
#define C_BLACK rgb(0, 0, 0)

using fb

randomize(timer())


sub initRegions(r as region ptr, worldSize as integer)
    dim as Pnt topLeft, botRight
    for y as integer = 0 to worldSize-1
        for x as integer = 0 to worldSize-1
            dim as integer i = IDX(y, x, worldSize)
            topLeft.set(x * REGION_SIZE, y * REGION_SIZE)
            botRight.set(x * REGION_SIZE + REGION_SIZE, y * REGION_SIZE + REGION_SIZE)
            r[i] = type<region>(topLeft, botRight)
        next x
    next y
end sub

sub initDots(d as Dot ptr, count as integer, max_x as integer, max_y as integer)
    for i as integer = 0 to count-1
        d[i].setPosition(max_x * rnd(), max_y * rnd())
    next i
end sub

sub renderRegions(r as region ptr, worldSize as integer, mPos as Pnt)
    for y as integer = 0 to worldSize-1
        for x as integer = 0 to worldSize-1
            dim as integer i = IDX(x, y, worldSize)
            if(r[i].inBoundary(mPos)) then
                line(r[i].topLeft.x, r[i].topLeft.y)-(r[i].botRight.x, r[i].botRight.y), rgb(100, 128, 100), bf
                line(r[i].topLeft.x, r[i].topLeft.y)-(r[i].botRight.x, r[i].botRight.y), rgb(200, 200, 200), b
            else
                line(r[i].topLeft.x, r[i].topLeft.y)-(r[i].botRight.x, r[i].botRight.y), rgb(100, 100, 100), bf
                line(r[i].topLeft.x, r[i].topLeft.y)-(r[i].botRight.x, r[i].botRight.y), rgb(200, 200, 200), b
            end if
        next x
    next y
end sub

sub addDotToWorld(d as Dot ptr, r as region ptr, worldSize as integer)
    for y as integer = 0 to worldSize-1
        for x as integer = 0 to worldSize-1
            dim as integer i = IDX(x, y, worldSize)
            if(r[i].inBoundary(d->position)) then
                r[i].add(d)
            end if
        next x
    next y
end sub

sub renderDots(r as region ptr)
    dim as dotNode ptr curr = r->first->nxt
    while(curr->n)
        circle(curr->n->position.x, curr->n->position.y), 2, rgb(100, 100, 100),,,,f
        curr = curr->nxt
    wend
end sub

sub renderDots_raw(d as Dot ptr, count as integer)
    for i as integer = 0 to count-1
        circle(d[i].position.x, d[i].position.y), 2, rgb(100, 255, 100),,,,f
    next i
end sub

'----------------

dim as EVENT e
dim as Pnt mPos
dim as boolean runApp = true

dim as integer regionDotCount = 0

dim as region ptr regions = new region[WORLD_SIZE * WORLD_SIZE]
dim as integer dotCount = 100
dim as Dot ptr dots = new Dot[dotCount]

print("Init regions...")
initRegions(regions, WORLD_SIZE)
print("Done!")

print("Init dots...")
initDots(dots, dotCount, WORLD_SIZE * REGION_SIZE, WORLD_SIZE * REGION_SIZE)
print("Done!")

screenRes(800, 600, 32, 1, 0)

while(runApp)
    if(multikey(sc_escape)) then runApp = false
    if(screenEvent(@e)) then
        select case e.type
        case EVENT_MOUSE_MOVE
            mPos.set(e.x, e.y)
        case EVENT_MOUSE_EXIT
            mPos.set(-1,-1)
        end select
    end if
    
    screenLock()
    
    cls()
    renderRegions(regions, WORLD_SIZE, mPos)
    'renderDots_raw(dots, dotCount)
    draw string(15, 15), str(mPos.x)
    draw string(15, 25), str(mPos.y)
    draw string(15, 35), str(regionDotCount)
    
    screenUnlock()
    
    sleep(1,1)
wend

sleep()

'Cleanup
delete[] regions
regions = 0