#include "fbgfx.bi"
using fb

dim shared as byte en = 0
dim as integer x,y

sub render(p as any ptr)
    var x = 0
    do
        x+=1
        locate(6,5):print len(x)
        locate(6,5):print x
        sleep 10,1
        
        if en then exit sub
    loop
end sub

dim as any ptr thr

thr = threadCreate(@render,0)

do
    if multikey(sc_escape) then en = 1
    
    if multikey(sc_w) then 
        y+=1
        locate(5,5):print len(x & !"\t" & y)
        locate(5,5):print x,y
    end if
    
    sleep 1,1
loop until en = 1

threadwait(thr)

print "ending"

While Inkey <> "": Wend

sleep