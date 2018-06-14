#include once "crt.bi"

#DEFINE LISTALLOCSIZE 64

#MACRO DeclareList(_T)
type _T##List
    as uinteger allocated, n
    as _T ptr item
    
    declare constructor()
    declare constructor(n as integer, value as _T)
    declare destructor()
    
    declare sub Allocate()
    declare sub Deallocate()
    declare sub Dispose()
    declare sub Clear()
    declare sub Add()
    declare sub Add(newItem as _T)
    declare sub Remove(index as uinteger)
    declare function Count() as uinteger
    declare function SwapItem(srcIndex as uinteger, dstIndex as uinteger) as boolean
    
    declare operator [](index as uinteger) as _T
end type

'Constructors

constructor _T##List()
    item = new _T[LISTALLOCSIZE]
    allocated = LISTALLOCSIZE
end constructor

constructor _T##List(n as integer, value as _T)
    if(n > 0) then
        for i as integer = 0 to n-1
            this.add(value)
        next i
    end if
end constructor

'Destructor

destructor _T##List()
    delete[] this.item
end destructor

'Methods

sub _T##List.Allocate()
    allocated+=LISTALLOCSIZE
    dim as _T ptr temp = new _T[allocated]
    memmove(temp, this.item, (this.allocated-LISTALLOCSIZE)*sizeof(_T))
    delete[] this.item
    this.item = temp
end sub

sub _T##List.Deallocate()
    this.allocated-=LISTALLOCSIZE
    dim as _T ptr temp = new _T[this.allocated]
    memmove(temp, this.item, (this.allocated-LISTALLOCSIZE)*sizeof(_T))
    delete[] this.item
    this.item = temp
end sub

sub _T##List.Dispose()
    delete[] this.item
end sub

sub _T##List.Clear()
    this.n = 0
    delete[] this.item
    this.item = new _T[LISTALLOCSIZE]
end sub

sub _T##List.Add()
    dim as _T newItem
    if(n >= this.allocated) then this.allocate()
    this.n+=1
    this.item[n-1] = newItem
end sub

sub _T##List.Add(newItem as _T)
    if(n >= this.allocated) then this.allocate()
    this.n+=1
    this.item[n-1] = newItem
end sub

sub _T##List.Remove(index as uinteger)
    if(this.n = 0 OR index > this.n) then return
    memmove(@cptr(_T ptr, this.item)[index], @cptr(_T ptr, this.item)[index+1], sizeof(_T)*(this.n-index-1))
    this.n-=1
    if(n+(LISTALLOCSIZE\2)) < (this.allocated-LISTALLOCSIZE) then this.deallocate()
end sub

function _T##List.Count() as uinteger
    return this.n
end function

function _T##List.SwapItem(srcIndex as uinteger, dstIndex as uinteger) as boolean
    dim as boolean result = false
    if(dstIndex <= this.n-1 AND srcIndex <= this.n-1) then
        swap this.item[srcIndex], this.item[dstIndex]
        result = true
    end if
    return result
end function

'Operators

operator _T##List.[](index as uinteger) as _T
    if(index < this.n) then
        return this.item[index]
    end if
end operator
#ENDMACRO

#MACRO forEach(_V, _L)
for i as uinteger = 1 to _L##.n
    dim as typeof(*_L##.item) _V = _L##.item[i-1]
#ENDMACRO
