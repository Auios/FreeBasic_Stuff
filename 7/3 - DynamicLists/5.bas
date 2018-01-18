#define ListVar(_T,_L) cptr(_T ptr,_L)
#define CreateList2( _T , _N ) allocate( (_N) * sizeof(_T) )

type thing
    as single a
end type

type List
    as any ptr items
end type

'function CreateList(

dim as List myList
myList.items = CreateList2(thing, 4)
