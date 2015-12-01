#include "fbgfx.bi"
#include "wshelper.bas"
using fb

randomize timer

hStart()

var serverSocket = hOpen()
var serverPort = 28000

dim as socket tmpSock
dim as long tmpPort,tmpIP
dim as string tmpMsg = space(512)

print hBind(serverSocket,serverPort)
print hListen(serverSocket)

sleep 2000

do
    print "Checking..."
    if hSelect(serverSocket) then
        print "Connection!"
        tmpSock = haccept(serverSocket,tmpIP,tmpPort)
        hreceive(tmpSock,tmpMsg,len(tmpMsg))
        print tmpMsg
        exit do
    end if
    sleep 500
loop until multikey(sc_escape)



hClose(tmpSock)
hClose(serverSocket)
sleep