#include "fbgfx.bi"
#include "wshelper.bas"

using fb

randomize timer

hstart()

dim as long port = 28000

var sock = hopen()
hbind(sock,port)
hlisten(sock)

dim as long clip,clport
dim as socket clsock

dim as short varr = 501

print varr,sizeof(varr)
do
    if hselect(sock) then
        print "Client connected"
        clsock = haccept(sock,clip,clport)
        
        hsend(clsock,cast(any ptr,@varr),sizeof(short))
        hclose(clsock)
        clsock = 0
    end if
    
    sleep 20,1
loop until multikey(sc_escape)