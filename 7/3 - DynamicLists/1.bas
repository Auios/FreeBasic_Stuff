dim as any ptr a

dim as short b = 5
dim as short c = 5

a = allocate(sizeof(short) * 2)
a = @b
'a[2] = @c

print cast(short ptr, a)[0]
print cast(short ptr, a)[2]
print sizeof(any ptr ptr)

sleep()