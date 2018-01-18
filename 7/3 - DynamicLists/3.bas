type Vector2D
    as single x,y
end type

function createVector2D(x as single, y as single) as Vector2D
    return type<Vector2D>(x,y)
end function

sub printVector2D(v as Vector2D)
    print v.x, v.y
end sub

type List
    as any ptr ptr item
    as uinteger itemSize
    as uinteger allocatedItems
'    as uinteger itemCount
end type

function createList(count as uinteger, itemSize as uinteger) as List
    dim as List newList
    with newList
        .itemSize = itemSize
'        .itemCount = 0
        .allocatedItems = 8
        .item = new any ptr[.allocatedItems]
    end with
    return newList
end function

sub setListItem(l as List, index as uinteger, item as any ptr)
    if(index >= l.allocatedItems) then return
    dim as any ptr newItem = allocate(l.itemSize)
    l.item[index] = newItem
end sub

function getListItem(l as List, index as uinteger) as any ptr
    return l.item[index]
end function

'====================

dim as List vectorList = createList(4, sizeof(Vector2D))
dim as Vector2D v1, v2, v3, vA, vB, vC

v1 = createVector2D(2,6)
v2 = createVector2D(91,53)
v3 = createVector2D(8.5,11.1)

setListItem(vectorList, 0, cast(any ptr, @v1))
setListItem(vectorList, 1, cast(any ptr, @v2))
setListItem(vectorList, 2, cast(any ptr, @v3))

vA = *cptr(Vector2D ptr, getListItem(vectorList, 0))
vB = *cptr(Vector2D ptr, getListItem(vectorList, 1))
vC = *cptr(Vector2D ptr, getListItem(vectorList, 2))

print("Before:")
printVector2D(v1)
printVector2D(v2)
printVector2D(v3)

print(!"\nAfter")
printVector2D(vA)
printVector2D(vB)
printVector2D(vC)

sleep()