#pragma once

#inclib "test"

type testStruct
    as integer data
end type

declare function modifyStruct alias "modifyStruct"(byval test as testStruct ptr) as testStruct ptr
declare sub sayHello alias "sayHello"()
declare function add alias "add"(byval a as integer, byval b as integer) as integer
