#define List(_T,_L) cptr(_T ptr,_L)
#define CreateList( _T , _N ) allocate( (_N) * sizeof(_T) )

type vector
    as single x,y
end type

dim as any ptr myList

myList = CreateList(vector, 2)

dim as vector v1,v2
v1.x = 2
v1.y = 6

v2.x = 99
v2.y = 26

List(vector, myList)[0] = v1
List(vector, myList)[1] = v2

print List(vector, myList)[0].x
print List(vector, myList)[0].y
print
print List(vector, myList)[1].x
print List(vector, myList)[1].y

sleep()