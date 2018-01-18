#include once "crt.bi"

#macro DeclareList(_T)

#ifndef LISTJUMPSIZE
#define LISTJUMPSIZE 32
#endif

type _T##List
    as uinteger allocated, count
    as _T ptr item
    
    declare constructor()
    declare sub allocate()
    declare sub deallocate()
    declare sub add(newItem as _T)
    declare sub remove(index as uinteger)
end type

constructor _T##List
    item = new _T[LISTJUMPSIZE]
    allocated = LISTJUMPSIZE
end constructor

sub _T##List.allocate()
    allocated+=LISTJUMPSIZE
    dim as _T ptr temp = new _T[allocated]
    memmove(temp, item, (allocated-LISTJUMPSIZE)*sizeof(_T))
    delete[] item
    item = temp
end sub

sub _T##List.deallocate()
    allocated-=LISTJUMPSIZE
    dim as _T ptr temp = new _T[allocated]
    memmove(temp, item, (allocated-LISTJUMPSIZE)*sizeof(_T))
    delete[] item
    item = temp
end sub

sub _T##List.add(newItem as _T)
    if(count >= allocated) then this.allocate()
    count+=1
    item[count-1] = newItem
end sub

sub _T##List.remove(index as uinteger)
    if(count = 0 OR index > count) then return
    memmove(@cptr(_T ptr,item)[index], @cptr(_T ptr,item)[index+1], sizeof(_T)*(count-index-1))
    count-=1
    if(count+(LISTJUMPSIZE\2)) < (allocated-LISTJUMPSIZE) then this.deallocate()
end sub
#undef LISTJUMPSIZE
#endMacro

DeclareList(integer)
dim as integerList list

list.add(4)
list.add(7)
list.add(24)
list.add(55)
list.add(215)
list.add(1)
list.add(2)
list.add(3)

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

list.remove(1)
list.add(88)
list.remove(1)
list.add(101)
list.add(102)

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