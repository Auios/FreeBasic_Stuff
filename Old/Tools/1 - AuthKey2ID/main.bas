#include "fbgfx.bi"
using fb

dim as string key, keyalpha = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
dim as string kchar, achar
dim as integer ID, tID
var eop=0

do
    input "Input: ", key
    if len(key)<>5 then
        print "Invalid key"
    else
        for i as integer = 1 to 5
            for j as integer = 1 to len(keyalpha)
                kchar = UCase(mid(key,i,1))
                achar = mid(keyalpha,j,1)
                
                if kchar = achar then tID = j-1
            next j
            print tID
            ID+=32^(5-i)*(tID)
        next i
    end if
    
    print "ID: " & ID
    ID = 0
    sleep
loop until multikey(sc_escape)