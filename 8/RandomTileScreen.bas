#include "fbgfx.bi"

using fb

dim as integer sw = 800
dim as integer sh = 600
dim as integer size = 4
screenRes(sw, sh, 32, 1, 0)

function createRandomTile(size as integer, t as integer = 0) as any ptr
    dim as any ptr img = imageCreate(size, size, rgb(0,0,0))
    select case t
    case 0
        for y as integer = 0 to size-1
            for x as integer = 0 to size-1
                dim as uinteger clr = 255*int(rnd()*2)
                'pset img, (x, y), rgb(255*rnd(),255*rnd(),255*rnd())
                'pset img, (x, y), rgb(100*rnd()+100,100*rnd()+100,100*rnd()+100)
                'pset img, (x, y), rgb(clr, clr, clr)
                circle img, (x, y), size, rgb(clr*rnd(), clr, clr)
            next x
        next y
    case 1
        dim as uinteger clr = 255*rnd()
        for i as integer = 0 to (size*2)*rnd()
            circle img, (size*rnd(), size*rnd()), (size/2)*0.05, rgb(clr, clr, clr),,,,f
        next i
    end select
    return img
end function

sub render(img as any ptr, size as integer, scx as integer, scy as integer)
    for y as integer = 0 to scy/size
        for x as integer = 0 to scx/size
            put(x * size, y * size), img, pset
        next x
    next y
end sub

dim as integer t = 0
dim as any ptr img = createRandomTile(size, t)

dim as boolean runApp = true
while(runApp)
    if(multikey(sc_escape)) then 
        runApp = false
    elseif(multikey(sc_r)) then
        imageDestroy(img)
        img = createRandomTile(size, t)
    elseif(multikey(sc_1)) then
        t = 0
        imageDestroy(img)
        img = createRandomTile(size, t)
    elseif(multikey(sc_2)) then
        t = 1
        imageDestroy(img)
        img = createRandomTile(size, t)
    elseif(multikey(sc_up)) then
        size+=1
        imageDestroy(img)
        img = createRandomTile(size, t)
    elseif(multikey(sc_down) AND size > 1) then
        size-=1
        imageDestroy(img)
        img = createRandomTile(size, t)
    end if
    
    screenLock()
    cls()
    render(img, size, sw, sh)
    screenUnlock()
    
    sleep(10, 1)
wend

imageDestroy(img)

sleep()