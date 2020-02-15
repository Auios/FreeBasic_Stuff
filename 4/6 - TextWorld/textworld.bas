'#include "scrn.bas"
#include "fbgfx.bi"
using fb

randomize timer

'scrn()
screenRes(800, 600, 32, 1, 0)

print "start"

dim as string buffer = "Hello world!"
dim as integer ff = freefile

open "test.txt" for binary as #ff
put #ff,,buffer
close #ff

buffer = ""
print buffer

open "test.txt" for binary as #ff
get #ff,,buffer
close #ff

print buffer
print "end"

sleep