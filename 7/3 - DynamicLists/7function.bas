#include once "crt.bi"

#macro DeclareList(_T)

#ifndef LISTJUMPSIZE
#define LISTJUMPSIZE 4
#endif

type _T##List
    as uinteger allocated, count
    as _T ptr item
    
    
    
    
    
    
end type

sub _T##ListInit(byref list as _T##List)
    list.item = new _T[LISTJUMPSIZE]
    list.allocated = LISTJUMPSIZE
end sub

sub _T##ListAllocate(byref list as _T##List)
    list.allocated+=LISTJUMPSIZE
    dim as _T ptr temp = new _T[list.allocated]
    memmove(temp, list.item, (list.allocated-LISTJUMPSIZE)*sizeof(_T))
    delete[] list.item
    list.item = temp
end sub

sub _T##ListDeallocate(byref list as _T##List)
    list.allocated-=LISTJUMPSIZE
    dim as _T ptr temp = new _T[list.allocated]
    memmove(temp, list.item, (list.allocated-LISTJUMPSIZE)*sizeof(_T))
    delete[] list.item
    list.item = temp
end sub

sub _T##ListAdd(byref list as _T##List, newItem as _T)
    if(list.count >= list.allocated) then _T##ListAllocate(list)
    list.count+=1
    list.item[list.count-1] = newItem
end sub

sub _T##ListRemove(byref list as _T##List, index as uinteger)
    if(list.count = 0 OR index > list.count) then return
    memmove(@cptr(_T ptr, list.item)[index], @cptr(_T ptr, list.item)[index+1], sizeof(_T)*(list.count - index - 1))
    list.count-=1
    if(list.count+(LISTJUMPSIZE\2)) < (list.allocated-LISTJUMPSIZE) then _T##ListDeallocate(list)
end sub
#undef ALSIZE
#endMacro

DeclareList(integer)
dim as integerList list

integerListAdd(list, 4)
integerListAdd(list, 7)
integerListAdd(list, 24)
integerListAdd(list, 55)
integerListAdd(list, 215)
integerListAdd(list, 1)
integerListAdd(list, 2)
integerListAdd(list, 3)

print(!"\Before:")
print "0: " & list.item[0]
print "1: " & list.item[1]
print "2: " & list.item[2]
print "3: " & list.item[3]
print "4: " & list.item[4]
print "5: " & list.item[5]
print "6: " & list.item[6]
print "7: " & list.item[7]
print "8: " & list.item[8]
print "9: " & list.item[9]
print "10: " & list.item[10]
print "11: " & list.item[11]

integerListRemove(list, 1)
integerListAdd(list, 88)
integerListRemove(list, 1)
integerListAdd(list, 101)
integerListAdd(list, 102)

print(!"\nAfter:")
print "0: " & list.item[0]
print "1: " & list.item[1]
print "2: " & list.item[2]
print "3: " & list.item[3]
print "4: " & list.item[4]
print "5: " & list.item[5]
print "6: " & list.item[6]
print "7: " & list.item[7]
print "8: " & list.item[8]
print "9: " & list.item[9]
print "10: " & list.item[10]
print "11: " & list.item[11]

sleep()

delete[] list.item