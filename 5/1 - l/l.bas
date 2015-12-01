#include "scrn.bas"
#include "fbgfx.bi"
using fb

setScrn()

if scrn() = 0 then
    print "Ok..."
else
    print "Fail..."
end if

sleep