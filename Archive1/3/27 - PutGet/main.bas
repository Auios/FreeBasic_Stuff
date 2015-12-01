#include "fbgfx.bi"
using fb
randomize timer

dim as short ff
dim as integer x,y
dim as string filename = "data.txt"

type entprop
    as string sign
    as integer x,y
end type
dim shared as entprop ent

ent.sign = "HELLO WORLD"
ent.x = 50
ent.y = 100

print filename
print ent.sign
print ent.x
print ent.y

ff = freefile

open filename for random as #ff

put #ff,,filename
put #ff,,ent

close #ff

ent.sign = ""
ent.x = 0
ent.y = 0

ff = freefile

open filename for random as #ff

get #ff,,filename
get #ff,,ent

close #ff

print filename
print ent.sign
print ent.x
print ent.y

sleep

end