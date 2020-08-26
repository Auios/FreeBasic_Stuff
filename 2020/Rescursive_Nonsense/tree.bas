#include "fbgfx.bi"

#define CHILDREN_START_SIZE 4
#define SIZE 100

using fb

type person
    as integer childrenSize
    as integer childrenCount
    as person ptr children
    as person ptr parent
end type

function createPerson(parent as person ptr = 0) as person
    dim as person p
    p.childrenSize = CHILDREN_START_SIZE
    p.childrenCount = 0
    p.children = new person[CHILDREN_START_SIZE]
    p.parent = parent
    return p
end function

function getTotalChildren(p as person ptr) as integer
    dim as integer totalChildren = p->childrenCount
    for i as integer = 0 to p->childrenCount-1
        totalChildren += getTotalChildren(@p->children[i])
    next i
    return totalChildren
end function

function getHighestChildrenCount(p as person ptr) as integer
    dim as integer highestChildrenCount = p->childrenCount
    for i as integer = 0 to p->childrenCount-1
        dim as integer count = getHighestChildrenCount(@p->children[i])
        if(count > highestChildrenCount) then highestChildrenCount = count
    next i
    return highestChildrenCount
end function

function getTreeWidth(p as person ptr) as integer
    dim as person ptr ptr pp = new person ptr[getTotalChildren(p)+1]
    
    dim as integer high = 0
    
    delete[] pp
    return high
end function

sub addPersonRandomly(p as person ptr)
    
end sub

sub addChild(p as person ptr)
    if(p->childrenCount >= p->childrenSize) then
        ' Allocate more space
        dim as person ptr newChildren = new person[p->childrenSize*2]
        for i as integer = 0 to p->childrenSize-1
            newChildren[i] = p->children[i]
        next i
        delete[] p->children
        p->children = newChildren
        p->childrenSize *= 2
    end if
    p->children[p->childrenCount] = createPerson(p)
    p->childrenCount += 1
end sub

sub renderPersonTree(p as person ptr, x as single, y as single)
    if(p = 0) then return
    
    dim as single nx ' New x
    dim as single ny ' New y
    
    circle(x, y), SIZE/4,rgb(200, 100, 100),,,,f
    
    for i as integer = 0 to p->childrenCount-1
        nx = x + (i * SIZE)
        ny = y + SIZE
        line(x, y)-(nx, ny),rgb(100, 100, 100)
        renderPersonTree(@p->children[i], nx, ny)
        draw string(nx-(8*len(str(i))), ny-10), str(i)
    next i
    
'    dim as integer highestChildrenCount = 0
'    dim as single position
'    dim as single offset
'    dim as single nx ' New x
'    dim as single ny ' New y
'    
'    circle(x, y), SIZE/4,rgb(200, 100, 100),,,,f
'    
'    for i as integer = 0 to p->childrenCount-1
'        position = i*SIZE + offset
'        offset = (highestChildrenCount-iif(i>0,1,0))*SIZE
'        if(offset < 0) then offset = 0
'        nx = x+position+offset
'        ny = y+SIZE
'        line(x, y)-(nx, ny),rgb(100, 100, 100)
'        renderPersonTree(@p->children[i], nx, ny)
'        draw string(nx-(8*len(str(i))), ny-10), str(i)
'        highestChildrenCount = getHighestChildrenCount(@p->children[i])
'    next i
end sub

function main() as integer
    dim as boolean closeApp = false
    dim as EVENT e
    
    screenres(800, 600, 32)
    
    dim as person p = createPerson()
    addChild(@p)
    addChild(@p)
    'addChild(@p)
    
    addChild(@p.children[0])

    addChild(@p.children[1])
    addChild(@p.children[1])

    'addChild(@p.children[2])

    addChild(@p.children[0].children[0])
    addChild(@p.children[0].children[0])

    'print(p.children[1].childrenCount):sleep()
    'print(getHighestChildrenCount(@p)):sleep()
    print(getTreeWidth(@p)):sleep()
    
    while(NOT closeApp)
        if(screenEvent(@e)) then
            select case e.type
            case EVENT_KEY_RELEASE
                if(e.scancode = SC_ESCAPE) then closeApp = true
                if(e.scancode = SC_SPACE) then addPersonRandomly(@p)
            end select
        end if
        
        screenLock()
        cls()
        renderPersonTree(@p, 50, 60)
        draw string(15, 15), "Total: " & str(getTotalChildren(@p))
        screenUnlock()
        sleep(1, 1)
    wend
    
    screen(0)
    
    return 0
end function

end(main())
