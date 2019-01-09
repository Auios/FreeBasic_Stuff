#include "fbgfx.bi"

using fb

randomize(timer())

screenRes(800,600, 32, 1, 0)

type Person
    as integer ID
    as integer childrenCount
    as Person ptr children
    
    declare sub addChild(p as Person)
    declare sub render(byref x as integer, byref y as integer)
end type

sub Person.addChild(p as Person)
    childrenCount+=1
    if(childrenCount = 1) then
        children = new Person[1]
        children[0] = p
    else
        dim as Person ptr tempChildren = new Person[childrenCount]
        for i as integer = 0 to childrenCount-2
            tempChildren[i] = children[i]
        next i
        tempChildren[childrenCount-1] = p
        delete[] children
        children = tempChildren
    end if
end sub

sub Person.render(byref x as integer, byref y as integer)
    if(childrenCount > 0) then
        for i as integer = 0 to childrenCount-1
            children[i].render(x)
            circle(zz, 100), 5
            zz+=10
        next i
    else
        circle(zz, 100), 5
    end if
end sub

dim as Person ptr p = new Person[16]
for i as integer = 0 to 15
    p[i].ID = i
next i

p[0].addChild(p[1])
p[0].addChild(p[2])
p[0].addChild(p[3])
p[0].addChild(p[4])
print p[0].childrenCount

p[1].addChild(p[5])
p[1].addChild(p[6])
p[1].addChild(p[7])
print p[1].childrenCount

p[5].addChild(p[12])
print p[5].childrenCount

p[10].addChild(p[13])
p[10].addChild(p[14])
print p[10].childrenCount

p[11].addChild(p[15])
print p[11].childrenCount

dim as integer x = 50
p[0].render(x)

sleep()