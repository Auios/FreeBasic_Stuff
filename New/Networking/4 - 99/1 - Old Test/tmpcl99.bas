#include "fbgfx.bi"
#include "wshelper.bas"
using fb

randomize timer

hStart()

dim as string hostIP = "localhost"
var mySocket = hOpen()
var ServerPort = 28000

print "Attempting to connect to host..."

var MyIP = hResolve(HostIP)
var iResu = hConnect(mySocket,MyIP,ServerPort)'socket/ip/port
if iResu then
    print "Connected..."
else
    print "Connection failed..."
    sleep:stop 1
end if

dim as string tmpMsg = "ping"
hSend(mySocket,tmpMsg,len(tmpMsg))
print "Message sent"

sleep

hClose(mySocket)