#include "vbcompat.bi"
#include "fbgfx.bi"
using fb

Dim As Double a = Now(),b

do
    a = now()
    if a <> b then Print Format(a, "yyyy/mm/dd hh:mm:ss") 
    b = a
    sleep 250
loop until multikey(sc_escape)