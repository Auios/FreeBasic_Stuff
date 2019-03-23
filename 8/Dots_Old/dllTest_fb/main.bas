#include "test.bi"

sayHello()

print add(5,2)

dim as testStruct test
test.data = 9
modifyStruct(@test)
print test.data

sleep()