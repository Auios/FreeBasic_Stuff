#include "wshelper.bas"
#include "fbgfx.bi"
using fb

var hostIP = "localhost"
dim as long port = 28000

hstart()

dim as integer iresu

var myIP = hresolve(hostip)
var sock = hOpen()

iResu = hConnect(sock,MyIP,Port)'socket/ip/port
if iResu then
    print "Connected..."
else
    print "Connection failed..."
    sleep:stop 1
end if

dim as short smsg

do
    if hselect(sock) then
        iResu = hReceive(sock,cast(any ptr,@smsg),sizeof(byte))
        
        if iResu <=0 then
            print "Server shutdown..."
            sleep
            exit do
        else
            print smsg
            sleep
        end if
    end if
loop until multikey(sc_escape)

hclose(sock)