type something
    as integer x,y
end type

dim as uinteger itemSize = sizeof(something)
dim as uinteger count
dim as uinteger indexCount
dim as any ptr ptr list

function createList(count as uinteger, size as uinteger) as any ptr ptr
    dim as any ptr ptr list = new any ptr[count]
    for i as integer = 0 to count-1
        list[i] = allocate(size)
    next i
    return list
end function

function getItem(thisList any ptr ptr, index) as any ptr

list = createList(4,sizeof(something))

'n = new any ptr[32]
'indexCount = 32
'>:
'dim as something new1, new2
'new1.x = 2
'new1.y = 7
'
'new2.x = 98
'new2.y = 57
'
'n[0] = allocate(sizeof(something))
'n[0] = @new1
'
'n[1] = allocate(sizeof(something))
'n[1] = @new2
'
'
'with *cptr(something ptr, n[0])
'    print .y
'end with
''print "" & cast(something ptr,n[0])->y
'
'sleep()

delete[] n
